"""HTTP API routes. Business logic remains in services/repositories."""
from __future__ import annotations

import io
from typing import Optional

from flask import Blueprint, jsonify, request, send_file

from backend.config import config
from backend.exporters import export_artifact
from backend.llm.factory import list_available_adapters
from backend.parsers import extract_scenarios, parse_feature_file
from backend.repository import FeatureRepository
from backend.services import GenerationResult, GenerationService


api_blueprint = Blueprint("api", __name__, url_prefix="/api")
_generation_service: Optional[GenerationService] = None
_feature_repository: Optional[FeatureRepository] = None


def get_generation_service() -> GenerationService:
    global _generation_service
    if _generation_service is None:
        llm_config = config.get_active_llm_config()
        _generation_service = GenerationService(
            provider=llm_config.provider,
            model=llm_config.model,
            auto_save=True,
        )
    return _generation_service


def get_feature_repository() -> FeatureRepository:
    global _feature_repository
    if _feature_repository is None:
        _feature_repository = FeatureRepository(config.features_dir)
    return _feature_repository


def _error(message: str, status: int, **extra):
    return jsonify({"success": False, "error": message, **extra}), status


def _result_response(result: GenerationResult):
    if not result.success:
        validation = result.validation.to_dict(include_content=False) if result.validation else None
        status = 422 if validation and validation.get("errors") else 502
        return _error(
            result.error or "Generation failed",
            status,
            validation=validation,
            metadata={
                "provider": result.provider,
                "model": result.model,
                "prompt_version": result.prompt_version,
                "latency_ms": result.latency_ms,
            },
        )
    return jsonify({
        "success": True,
        "result": result.content,
        "structured_data": result.structured_data,
        "artifact_id": result.artifact_id,
        "from_cache": result.from_cache,
        "validation": result.validation.to_dict(include_content=False) if result.validation else None,
        "metadata": {
            "provider": result.provider,
            "model": result.model,
            "prompt_version": result.prompt_version,
            "latency_ms": result.latency_ms,
            "source_context": result.source_context,
        },
    })


@api_blueprint.get("/features")
def list_features():
    try:
        return jsonify({
            "success": True,
            "features": [item.__dict__ for item in get_feature_repository().list_features()],
        })
    except Exception as exc:
        return _error(str(exc), 500)


@api_blueprint.get("/feature")
def read_feature():
    path = request.args.get("path", "")
    if not path:
        return _error("path parameter is required", 400)
    try:
        content = get_feature_repository().get_feature_content(path)
        return jsonify({"success": True, "content": content})
    except (ValueError, FileNotFoundError) as exc:
        return _error(str(exc), 400 if isinstance(exc, ValueError) else 404)


@api_blueprint.get("/parse-feature")
def parse_feature_endpoint():
    path = request.args.get("path", "")
    if not path:
        return _error("path parameter is required", 400)
    try:
        repo = get_feature_repository()
        safe_path = repo.resolve(path)
        content = safe_path.read_text(encoding="utf-8")
        relative_name = f"features/{safe_path.relative_to(repo.features_dir).as_posix()}"
        return jsonify({
            "success": True,
            "feature": parse_feature_file(content, relative_name),
            "scenarios": extract_scenarios(content, relative_name),
        })
    except (ValueError, FileNotFoundError) as exc:
        return _error(str(exc), 400 if isinstance(exc, ValueError) else 404)
    except Exception as exc:
        return _error(f"Feature parsing failed: {exc}", 422)


@api_blueprint.post("/parse-scenarios")
def parse_scenarios_endpoint():
    payload = request.get_json(silent=True) or {}
    text = str(payload.get("text") or "").strip()
    filename = str(payload.get("filename") or "<inline>").strip()
    if not text:
        return _error("text cannot be empty", 400)
    try:
        scenarios = extract_scenarios(text, filename)
        return jsonify({"success": True, "scenarios": scenarios, "count": len(scenarios)})
    except Exception as exc:
        return _error(f"Scenario parsing failed: {exc}", 422)


@api_blueprint.post("/generate")
def generate():
    payload = request.get_json(silent=True) or {}
    bdd_text = str(payload.get("text") or "").strip()
    action_type = str(payload.get("type") or "requirement").strip().lower()
    source_file = str(payload.get("source_file") or "<inline>").strip()
    if not bdd_text:
        return _error("text cannot be empty", 400)
    if len(bdd_text.encode("utf-8")) > config.max_content_length:
        return _error("BDD input exceeds the configured size limit", 413)

    service = get_generation_service()
    try:
        if action_type in {"requirement", "requirements"}:
            result = service.generate_requirements(bdd_text, source_file)
        elif action_type in {"testcase", "testcases"}:
            result = service.generate_testcases(bdd_text, source_file)
        elif action_type == "uml":
            diagram_type = str(payload.get("diagram_type") or "Sequence Diagram")
            result = service.generate_uml(bdd_text, diagram_type, source_file)
        else:
            return _error(f"Unsupported type: {action_type}", 400)
        return _result_response(result)
    except Exception as exc:
        return _error(f"Server error: {exc}", 500)


@api_blueprint.get("/outputs")
def list_outputs():
    output_type = request.args.get("type") or None
    try:
        limit = int(request.args.get("limit", "100"))
    except ValueError:
        return _error("limit must be an integer", 400)
    artifacts = get_generation_service().output_storage.list_outputs(output_type, limit)
    return jsonify({"success": True, "artifacts": artifacts})


@api_blueprint.get("/outputs/<artifact_id>")
def get_output(artifact_id: str):
    try:
        record = get_generation_service().output_storage.get_artifact(artifact_id)
    except ValueError as exc:
        return _error(str(exc), 400)
    if record is None:
        return _error("Artifact not found", 404)
    return jsonify({"success": True, "artifact": record.to_dict()})


@api_blueprint.get("/outputs/<artifact_id>/export/<format_name>")
def export_output(artifact_id: str, format_name: str):
    try:
        record = get_generation_service().output_storage.get_artifact(artifact_id)
        if record is None:
            return _error("Artifact not found", 404)
        data, mimetype, filename = export_artifact(record, format_name)
        return send_file(
            io.BytesIO(data),
            mimetype=mimetype,
            as_attachment=True,
            download_name=filename,
            max_age=0,
        )
    except ValueError as exc:
        return _error(str(exc), 400)
    except ImportError as exc:
        return _error(f"Exporter dependency is not installed: {exc}", 500)


@api_blueprint.post("/outputs/compare")
def compare_outputs():
    payload = request.get_json(silent=True) or {}
    left_id = str(payload.get("left_id") or "")
    right_id = str(payload.get("right_id") or "")
    if not left_id or not right_id:
        return _error("left_id and right_id are required", 400)
    try:
        comparison = get_generation_service().output_storage.compare(left_id, right_id)
        return jsonify({"success": True, "comparison": comparison})
    except ValueError as exc:
        return _error(str(exc), 400)
    except FileNotFoundError as exc:
        return _error(str(exc), 404)


@api_blueprint.patch("/outputs/<artifact_id>/review")
def review_output(artifact_id: str):
    payload = request.get_json(silent=True) or {}
    status = str(payload.get("status") or "").strip().lower()
    note = str(payload.get("note") or "")
    try:
        record = get_generation_service().output_storage.update_review(artifact_id, status, note)
        return jsonify({"success": True, "artifact": record.to_dict()})
    except ValueError as exc:
        return _error(str(exc), 400)
    except FileNotFoundError as exc:
        return _error(str(exc), 404)


@api_blueprint.post("/outputs/<artifact_id>/regenerate")
def regenerate_output(artifact_id: str):
    try:
        result = get_generation_service().regenerate_artifact(artifact_id)
        return _result_response(result)
    except ValueError as exc:
        return _error(str(exc), 400)
    except FileNotFoundError as exc:
        return _error(str(exc), 404)


@api_blueprint.get("/health")
def health_check():
    try:
        return jsonify({"success": True, "health": get_generation_service().health_check()})
    except Exception as exc:
        return _error(str(exc), 500)


@api_blueprint.get("/stats")
def stats():
    return jsonify({"success": True, "stats": get_generation_service().get_stats()})


@api_blueprint.get("/providers")
def providers():
    return jsonify({
        "success": True,
        "providers": list_available_adapters(),
        "active": config.active_llm,
    })
@api_blueprint.post("/translate")
def translate_endpoint():
    payload = request.get_json(silent=True) or {}
    text = str(payload.get("text") or "").strip()
    target_language = str(payload.get("target_language") or "Turkish").strip()
    if not text:
        return _error("text cannot be empty", 400)
    if len(text.encode("utf-8")) > config.max_content_length:
        return _error("Text exceeds the configured size limit", 413)

    service = get_generation_service()
    try:
        result = service.translate(text, target_language)
        return _result_response(result)
    except Exception as exc:
        return _error(f"Server error: {exc}", 500)
