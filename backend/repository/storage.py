"""Persistence for features, artifacts, logs and validated cache entries."""
from __future__ import annotations

import hashlib
import json
import os
import re
import tempfile
import uuid
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from difflib import unified_diff
from pathlib import Path
from typing import Any, Dict, List, Optional

from backend.config import config


_ARTIFACT_ID_RE = re.compile(r"^[a-f0-9]{32}$")


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _atomic_json_write(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", delete=False, dir=path.parent, suffix=".tmp"
    ) as handle:
        json.dump(payload, handle, ensure_ascii=False, indent=2)
        temp_name = handle.name
    os.replace(temp_name, path)


@dataclass
class GenerationLog:
    timestamp: str
    input_hash: str
    input_preview: str
    output_type: str
    provider: str
    model: str
    prompt_version: str
    success: bool
    latency_ms: Optional[float] = None
    error: Optional[str] = None
    artifact_id: Optional[str] = None
    from_cache: bool = False
    metadata: Dict[str, Any] = field(default_factory=dict)


@dataclass
class FeatureFile:
    path: str
    name: str
    content: Optional[str] = None


@dataclass
class ArtifactRecord:
    id: str
    output_type: str
    content: str
    structured_data: Optional[dict]
    source_text: Optional[str]
    source_context: Optional[dict]
    provider: str
    model: str
    prompt_version: str
    validation: dict
    created_at: str
    updated_at: str
    status: str = "draft"
    review_note: str = ""
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict:
        return asdict(self)

    def summary(self) -> dict:
        return {
            "id": self.id,
            "output_type": self.output_type,
            "provider": self.provider,
            "model": self.model,
            "prompt_version": self.prompt_version,
            "created_at": self.created_at,
            "updated_at": self.updated_at,
            "status": self.status,
            "review_note": self.review_note,
            "validation": {
                "valid": self.validation.get("valid", False),
                "warning_count": len(self.validation.get("warnings", [])),
                "error_count": len(self.validation.get("errors", [])),
            },
            "metadata": self.metadata,
        }


class OutputStorage:
    """Canonical artifact repository backed by atomic JSON files."""

    VALID_STATUSES = {"draft", "reviewed", "approved", "rejected"}

    def __init__(self, output_dir: Path | str = config.outputs_dir):
        self.output_dir = Path(output_dir).resolve()
        self.artifact_dir = self.output_dir / "artifacts"
        self.rendered_dir = self.output_dir / "rendered"
        self.artifact_dir.mkdir(parents=True, exist_ok=True)
        self.rendered_dir.mkdir(parents=True, exist_ok=True)

    def _path(self, artifact_id: str) -> Path:
        if not _ARTIFACT_ID_RE.fullmatch(artifact_id):
            raise ValueError("Invalid artifact ID")
        return self.artifact_dir / f"{artifact_id}.json"

    def save_artifact(
        self,
        *,
        output_type: str,
        content: str,
        structured_data: Optional[dict],
        source_text: Optional[str],
        source_context: Optional[dict],
        provider: str,
        model: str,
        prompt_version: str,
        validation: dict,
        metadata: Optional[dict] = None,
    ) -> ArtifactRecord:
        artifact_id = uuid.uuid4().hex
        now = _now()
        record = ArtifactRecord(
            id=artifact_id,
            output_type=output_type,
            content=content,
            structured_data=structured_data,
            source_text=source_text if config.store_source_inputs else None,
            source_context=source_context,
            provider=provider,
            model=model,
            prompt_version=prompt_version,
            validation=validation,
            created_at=now,
            updated_at=now,
            metadata=metadata or {},
        )
        _atomic_json_write(self._path(artifact_id), record.to_dict())

        extension = "puml" if output_type == "uml" else "md"
        (self.rendered_dir / f"{artifact_id}.{extension}").write_text(content, encoding="utf-8")
        return record

    # Backward-compatible helper.
    def save(self, content: str, output_type: str, filename: Optional[str] = None) -> str:
        extension = "puml" if output_type == "uml" else "md"
        safe_name = filename or f"{output_type}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.{extension}"
        safe_name = Path(safe_name).name
        path = self.rendered_dir / safe_name
        path.write_text(content, encoding="utf-8")
        return str(path)

    def get_artifact(self, artifact_id: str) -> Optional[ArtifactRecord]:
        path = self._path(artifact_id)
        if not path.is_file():
            return None
        try:
            return ArtifactRecord(**json.loads(path.read_text(encoding="utf-8")))
        except (json.JSONDecodeError, TypeError, OSError):
            return None

    def list_outputs(self, output_type: Optional[str] = None, limit: int = 100) -> List[dict]:
        records: List[ArtifactRecord] = []
        for path in self.artifact_dir.glob("*.json"):
            record = self.get_artifact(path.stem)
            if record and (output_type is None or record.output_type == output_type):
                records.append(record)
        records.sort(key=lambda item: item.created_at, reverse=True)
        return [record.summary() for record in records[: max(1, min(limit, 500))]]

    def update_review(self, artifact_id: str, status: str, note: str = "") -> ArtifactRecord:
        if status not in self.VALID_STATUSES:
            raise ValueError(f"Invalid status. Expected one of: {', '.join(sorted(self.VALID_STATUSES))}")
        record = self.get_artifact(artifact_id)
        if record is None:
            raise FileNotFoundError("Artifact not found")
        record.status = status
        record.review_note = note.strip()[:2000]
        record.updated_at = _now()
        _atomic_json_write(self._path(artifact_id), record.to_dict())
        return record

    def compare(self, left_id: str, right_id: str) -> dict:
        left = self.get_artifact(left_id)
        right = self.get_artifact(right_id)
        if left is None or right is None:
            raise FileNotFoundError("One or both artifacts were not found")
        diff = "\n".join(unified_diff(
            left.content.splitlines(),
            right.content.splitlines(),
            fromfile=left.id,
            tofile=right.id,
            lineterm="",
        ))
        return {
            "left": left.summary(),
            "right": right.summary(),
            "diff": diff,
            "same": left.content == right.content,
        }


class LogStorage:
    def __init__(self, log_dir: Path | str = config.logs_dir):
        self.log_dir = Path(log_dir).resolve()
        self.log_dir.mkdir(parents=True, exist_ok=True)
        self.log_file = self.log_dir / "generation_logs.jsonl"

    def log(self, entry: GenerationLog) -> None:
        with self.log_file.open("a", encoding="utf-8") as handle:
            handle.write(json.dumps(asdict(entry), ensure_ascii=False) + "\n")

    def get_logs(self, limit: int = 100, output_type: Optional[str] = None) -> List[GenerationLog]:
        if not self.log_file.exists():
            return []
        result: List[GenerationLog] = []
        for line in self.log_file.read_text(encoding="utf-8").splitlines():
            try:
                payload = json.loads(line)
                if output_type and payload.get("output_type") != output_type:
                    continue
                result.append(GenerationLog(**payload))
            except (json.JSONDecodeError, TypeError):
                continue
        return result[-max(1, min(limit, 5000)):]

    def get_stats(self) -> Dict[str, Any]:
        logs = self.get_logs(limit=5000)
        latencies = [item.latency_ms for item in logs if item.latency_ms is not None]
        by_type: Dict[str, int] = {}
        by_provider: Dict[str, int] = {}
        for item in logs:
            by_type[item.output_type] = by_type.get(item.output_type, 0) + 1
            by_provider[item.provider] = by_provider.get(item.provider, 0) + 1
        return {
            "total_generations": len(logs),
            "successful": sum(item.success for item in logs),
            "failed": sum(not item.success for item in logs),
            "cache_hits": sum(item.from_cache for item in logs),
            "by_type": by_type,
            "by_provider": by_provider,
            "avg_latency_ms": round(sum(latencies) / len(latencies), 2) if latencies else 0,
        }


class CacheStorage:
    """Validated generation cache keyed by input, model and prompt version."""

    def __init__(self, cache_dir: Path | str = config.outputs_dir / "cache"):
        self.cache_dir = Path(cache_dir).resolve()
        self.cache_dir.mkdir(parents=True, exist_ok=True)

    def _make_key(
        self,
        input_text: str,
        output_type: str,
        provider: str,
        model: str,
        prompt_version: str,
    ) -> str:
        raw = "|".join((output_type, provider, model, prompt_version, input_text.strip()))
        return hashlib.sha256(raw.encode("utf-8")).hexdigest()

    def get(
        self,
        input_text: str,
        output_type: str,
        provider: str,
        model: str,
        prompt_version: str,
    ) -> Optional[dict]:
        path = self.cache_dir / f"{self._make_key(input_text, output_type, provider, model, prompt_version)}.json"
        if not path.is_file():
            return None
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            return None
        validation = payload.get("validation") or {}
        if not validation.get("valid"):
            return None
        return payload

    def set(
        self,
        input_text: str,
        output_type: str,
        provider: str,
        model: str,
        prompt_version: str,
        *,
        content: str,
        structured_data: Optional[dict],
        validation: dict,
        artifact_id: Optional[str],
    ) -> None:
        if not validation.get("valid"):
            raise ValueError("Only validated results may be cached")
        key = self._make_key(input_text, output_type, provider, model, prompt_version)
        _atomic_json_write(self.cache_dir / f"{key}.json", {
            "schema_version": "2",
            "output_type": output_type,
            "provider": provider,
            "model": model,
            "prompt_version": prompt_version,
            "content": content,
            "structured_data": structured_data,
            "validation": validation,
            "artifact_id": artifact_id,
            "cached_at": _now(),
        })


class FeatureRepository:
    def __init__(self, features_dir: Path | str = config.features_dir):
        self.features_dir = Path(features_dir).resolve()

    def resolve(self, user_path: str) -> Path:
        if not user_path or "\x00" in user_path:
            raise ValueError("A valid feature path is required")
        normalized = user_path.replace("\\", "/")
        if normalized.startswith("features/"):
            normalized = normalized[len("features/"):]
        candidate = (self.features_dir / normalized).resolve()
        if not candidate.is_relative_to(self.features_dir):
            raise ValueError("Access outside the features directory is forbidden")
        if candidate.suffix.lower() != ".feature":
            raise ValueError("Only .feature files may be accessed")
        if not candidate.is_file():
            raise FileNotFoundError("Feature file not found")
        return candidate

    def list_features(self) -> List[FeatureFile]:
        if not self.features_dir.is_dir():
            return []
        result = []
        for path in self.features_dir.rglob("*.feature"):
            relative = path.relative_to(self.features_dir).as_posix()
            result.append(FeatureFile(path=f"features/{relative}", name=path.name))
        return sorted(result, key=lambda item: item.path.casefold())

    def get_feature_content(self, user_path: str) -> str:
        return self.resolve(user_path).read_text(encoding="utf-8")
