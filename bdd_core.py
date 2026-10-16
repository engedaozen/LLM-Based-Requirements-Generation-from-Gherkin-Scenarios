"""Backward-compatible public functions for Behave and legacy imports."""
from __future__ import annotations

from backend.config import config
from backend.services import GenerationService

_service: GenerationService | None = None


def _get_service() -> GenerationService:
    global _service
    if _service is None:
        llm_config = config.get_active_llm_config()
        _service = GenerationService(
            provider=llm_config.provider,
            model=llm_config.model,
            auto_save=True,
        )
    return _service


def generate_requirements(bdd_text: str) -> str:
    result = _get_service().generate_requirements(bdd_text)
    if not result.success:
        detail = result.error or "Unknown generation error"
        if result.validation and result.validation.errors:
            detail += "\n" + "\n".join(result.validation.errors)
        return f"Error: {detail}"
    return result.content


def generate_testcases(bdd_text: str) -> str:
    result = _get_service().generate_testcases(bdd_text)
    return result.content if result.success else f"Error: {result.error}"


def generate_uml_plantuml(bdd_text: str, diagram_type: str = "Sequence Diagram") -> str:
    result = _get_service().generate_uml(bdd_text, diagram_type)
    return result.content if result.success else f"Error: {result.error}"
