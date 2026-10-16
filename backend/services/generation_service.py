"""Generation orchestration for requirements, tests and UML artifacts."""
from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Optional


from backend.config import config
from backend.llm import BaseLLMAdapter, get_llm_adapter
from backend.parsers import (
    ValidationResult,
    build_source_context,
    parse_llm_output,
    validate_plantuml,
    validate_requirements_doc,
    validate_testcases,
)
from backend.prompts.templates import get_prompt, get_uml_instruction
from backend.repository import CacheStorage, GenerationLog, LogStorage, OutputStorage
from backend.prompts.templates import get_translation_prompt

@dataclass
class GenerationResult:
    success: bool
    content: str
    output_type: str
    provider: str
    model: str
    prompt_version: str
    validation: Optional[ValidationResult] = None
    structured_data: Optional[dict] = None
    source_context: Optional[dict] = None
    artifact_id: Optional[str] = None
    error: Optional[str] = None
    from_cache: bool = False
    latency_ms: Optional[float] = None


class GenerationService:
    def __init__(
        self,
        provider: str = "gemini",
        model: Optional[str] = None,
        auto_save: bool = True,
        log_enabled: bool = True,
        use_cache: bool = True,
        adapter: Optional[BaseLLMAdapter] = None,
        output_storage: Optional[OutputStorage] = None,
        log_storage: Optional[LogStorage] = None,
        cache_storage: Optional[CacheStorage] = None,
    ):
        self.adapter = adapter or get_llm_adapter(provider, model)
        self.output_storage = output_storage or OutputStorage()
        self.log_storage = log_storage or LogStorage()
        self.cache = cache_storage or CacheStorage()
        self.use_cache = use_cache
        self.auto_save = auto_save
        self.log_enabled = log_enabled

    def generate_requirements(
        self,
        bdd_text: str,
        source_file: str = "<inline>",
    ) -> GenerationResult:
        output_type = "requirements"
        prompt_template = get_prompt(output_type)
        source_context = build_source_context(bdd_text, source_file)
        prompt = prompt_template.render(
            source_json=json.dumps(source_context, ensure_ascii=False, indent=2)
        )
        return self._run_generation(
            input_text=bdd_text,
            output_type=output_type,
            prompt=prompt,
            prompt_version=prompt_template.version,
            source_context=source_context,
            response_format="json",
        )

    def generate_testcases(
        self,
        bdd_text: str,
        source_file: str = "<inline>",
    ) -> GenerationResult:
        prompt_template = get_prompt("testcases")
        source_context = build_source_context(bdd_text, source_file)
        return self._run_generation(
            input_text=bdd_text,
            output_type="testcases",
            prompt=prompt_template.render(bdd_text=bdd_text),
            prompt_version=prompt_template.version,
            source_context=source_context,
        )

    def generate_uml(
        self,
        bdd_text: str,
        diagram_type: str = "Sequence Diagram",
        source_file: str = "<inline>",
    ) -> GenerationResult:
        prompt_template = get_prompt("uml")
        source_context = build_source_context(bdd_text, source_file)
        cache_input = f"{diagram_type}\n{bdd_text}"
        return self._run_generation(
            input_text=cache_input,
            original_input=bdd_text,
            output_type="uml",
            prompt=prompt_template.render(
                bdd_text=bdd_text,
                instruction=get_uml_instruction(diagram_type),
            ),
            prompt_version=prompt_template.version,
            source_context=source_context,
            metadata={"diagram_type_requested": diagram_type},
        )
    def translate(
        self,
        text: str,
        target_language: str = "Turkish",
        source_file: str = "<inline>",
    ) -> GenerationResult:
        source_context = build_source_context(text, source_file)
        cache_input = f"{target_language}\n{text}"
        return self._run_generation(
            input_text=cache_input,
            original_input=text,
            output_type="translation",
            prompt=get_translation_prompt(text, target_language),
            prompt_version="translation-v1",
            source_context=source_context,
            metadata={"target_language": target_language},
        )
    

    def _run_generation(
        self,
        *,
        input_text: str,
        output_type: str,
        prompt: str,
        prompt_version: str,
        source_context: dict,
        original_input: Optional[str] = None,
        response_format: Optional[str] = None,
        metadata: Optional[dict] = None,
    ) -> GenerationResult:
        provider = self.adapter.provider_name
        model = self.adapter.model_name
        source_text = original_input if original_input is not None else input_text

        cached = self._cache_get(input_text, output_type, provider, model, prompt_version)
        if cached:
            validation_payload = cached.get("validation") or {}
            validation = ValidationResult(
                valid=bool(validation_payload.get("valid")),
                content=cached.get("content", ""),
                errors=list(validation_payload.get("errors") or []),
                warnings=list(validation_payload.get("warnings") or []),
                metadata=dict(validation_payload.get("metadata") or {}),
            )
            result = GenerationResult(
                success=True,
                content=cached.get("content", ""),
                output_type=output_type,
                provider=provider,
                model=model,
                prompt_version=prompt_version,
                validation=validation,
                structured_data=cached.get("structured_data"),
                source_context=source_context,
                artifact_id=cached.get("artifact_id"),
                from_cache=True,
            )
            self._log_generation(source_text, result)
            return result

        try:
            llm_response = self.adapter.generate(prompt, response_format=response_format)
        except Exception as exc:
            return self._failure(
                source_text,
                output_type,
                prompt_version,
                f"LLM adapter failure: {exc}",
                source_context,
            )

        if not llm_response.success:
            return self._failure(
                source_text,
                output_type,
                prompt_version,
                llm_response.error or "Generation failed",
                source_context,
                latency_ms=llm_response.latency_ms,
            )

        structured_data = None
        if output_type == "requirements":
            document = parse_llm_output(
                llm_response.text,
                source_context=source_context,
                provider=provider,
                model=model,
                prompt_version=prompt_version,
            )
            validation = validate_requirements_doc(document, source_context)
            structured_data = document.to_dict()
        elif output_type == "testcases":
            validation = validate_testcases(llm_response.text)
        elif output_type == "uml":
            validation = validate_plantuml(llm_response.text)
        elif output_type == "translation":
            validation = ValidationResult(True, llm_response.text.strip(), errors=[], warnings=[])
        else:
            validation = ValidationResult(False, "", errors=["Unsupported output type"])
        result = GenerationResult(
            success=validation.valid,
            content=validation.content,
            output_type=output_type,
            provider=provider,
            model=model,
            prompt_version=prompt_version,
            validation=validation,
            structured_data=structured_data,
            source_context=source_context,
            latency_ms=llm_response.latency_ms,
            error="; ".join(validation.errors) if not validation.valid else None,
        )

        if result.success:
            if self.auto_save:
                artifact = self.output_storage.save_artifact(
                    output_type=output_type,
                    content=result.content,
                    structured_data=structured_data,
                    source_text=source_text,
                    source_context=source_context,
                    provider=provider,
                    model=model,
                    prompt_version=prompt_version,
                    validation=validation.to_dict(include_content=False),
                    metadata={
                        **(metadata or {}),
                        "latency_ms": llm_response.latency_ms,
                        "tokens_used": llm_response.tokens_used,
                    },
                )
                result.artifact_id = artifact.id
            if self.use_cache:
                self.cache.set(
                    input_text,
                    output_type,
                    provider,
                    model,
                    prompt_version,
                    content=result.content,
                    structured_data=structured_data,
                    validation=validation.to_dict(include_content=False),
                    artifact_id=result.artifact_id,
                )

        self._log_generation(source_text, result)
        return result

    def _cache_get(
        self,
        input_text: str,
        output_type: str,
        provider: str,
        model: str,
        prompt_version: str,
    ) -> Optional[dict]:
        if not self.use_cache:
            return None
        return self.cache.get(input_text, output_type, provider, model, prompt_version)

    def _failure(
        self,
        input_text: str,
        output_type: str,
        prompt_version: str,
        error: str,
        source_context: Optional[dict] = None,
        latency_ms: Optional[float] = None,
    ) -> GenerationResult:
        result = GenerationResult(
            success=False,
            content="",
            output_type=output_type,
            provider=self.adapter.provider_name,
            model=self.adapter.model_name,
            prompt_version=prompt_version,
            source_context=source_context,
            error=error,
            latency_ms=latency_ms,
        )
        self._log_generation(input_text, result)
        return result

    def regenerate_artifact(self, artifact_id: str) -> GenerationResult:
        record = self.output_storage.get_artifact(artifact_id)
        if record is None:
            raise FileNotFoundError("Artifact not found")
        if not record.source_text:
            raise ValueError("Source input was not retained for this artifact")
        # Regeneration deliberately bypasses cache to create a new comparable
        # artifact under the current prompt/model version.
        previous_cache_setting = self.use_cache
        self.use_cache = False
        try:
            if record.output_type == "requirements":
                return self.generate_requirements(record.source_text, (record.source_context or {}).get("source_file", "<inline>"))
            if record.output_type == "testcases":
                return self.generate_testcases(record.source_text, (record.source_context or {}).get("source_file", "<inline>"))
            if record.output_type == "uml":
                diagram_type = record.metadata.get("diagram_type_requested", "Sequence Diagram")
                return self.generate_uml(record.source_text, diagram_type, (record.source_context or {}).get("source_file", "<inline>"))
            raise ValueError("Unsupported artifact type")
        finally:
            self.use_cache = previous_cache_setting

    def _log_generation(self, input_text: str, result: GenerationResult) -> None:
        if not self.log_enabled:
            return
        entry = GenerationLog(
            timestamp=datetime.now(timezone.utc).isoformat(),
            input_hash=hashlib.sha256(input_text.encode("utf-8")).hexdigest(),
            input_preview=input_text[:200] if config.debug else "",
            output_type=result.output_type,
            provider=result.provider,
            model=result.model,
            prompt_version=result.prompt_version,
            success=result.success,
            latency_ms=result.latency_ms,
            error=result.error,
            artifact_id=result.artifact_id,
            from_cache=result.from_cache,
            metadata=result.validation.metadata if result.validation else {},
        )
        try:
            self.log_storage.log(entry)
        except Exception:
            pass

    def get_stats(self) -> dict:
        return self.log_storage.get_stats()

    def health_check(self) -> dict:
        return {
            "service": "GenerationService",
            "llm": self.adapter.health_check(),
            "stats": self.get_stats(),
            "paths": {
                "features": str(config.features_dir),
                "outputs": str(config.outputs_dir),
            },
        }
    
