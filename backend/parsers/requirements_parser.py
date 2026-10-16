"""Structured requirement parsing, validation and rendering."""
from __future__ import annotations

import json
import re
from collections import Counter
from datetime import datetime, timezone
from difflib import SequenceMatcher
from typing import Any, Dict, Iterable, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from backend.parsers.validators import ValidationResult

RequirementType = Literal["functional", "non_functional", "security", "data", "business_rule"]
Priority = Literal["must", "should", "could", "wont"]

_PREFIX_BY_TYPE = {
    "functional": "FR-",
    "non_functional": "NFR-",
    "security": "SEC-",
    "data": "DR-",
    "business_rule": "BR-",
}


def _normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip()).casefold()


def _as_list(value: Any) -> List[str]:
    if value is None:
        return []
    if isinstance(value, list):
        return [str(item).strip() for item in value if str(item).strip()]
    if isinstance(value, str):
        return [value.strip()] if value.strip() else []
    return [str(value).strip()]


class SourceLocation(BaseModel):
    model_config = ConfigDict(extra="forbid")
    step_id: str = Field(min_length=6)
    source_file: str = Field(min_length=1)
    scenario: str = Field(min_length=1)
    start_line: int = Field(ge=1)
    end_line: int = Field(ge=1)

    @model_validator(mode="after")
    def end_not_before_start(self):
        if self.end_line < self.start_line:
            raise ValueError("end_line cannot be before start_line")
        return self


class Requirement(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    id: str = Field(pattern=r"^(FR|NFR|SEC|DR|BR)-\d{3,}$")
    type: RequirementType
    text: str = Field(min_length=12)
    source_feature: str = Field(min_length=1)
    source_scenario: str = Field(min_length=1)
    source_steps: List[str] = Field(min_length=1)
    source_step_ids: List[str] = Field(min_length=1)
    source_locations: List[SourceLocation] = Field(min_length=1)
    acceptance_criteria: List[str] = Field(min_length=1)
    parameters: List[str] = Field(default_factory=list)
    priority: Priority = "must"
    confidence: float = Field(ge=0.0, le=1.0)
    warnings: List[str] = Field(default_factory=list)

    @field_validator("source_steps", "source_step_ids", "acceptance_criteria", "parameters", "warnings")
    @classmethod
    def no_blank_items(cls, items: List[str]) -> List[str]:
        cleaned = [item.strip() for item in items if item and item.strip()]
        return cleaned

    @model_validator(mode="after")
    def type_and_id_match(self):
        expected = _PREFIX_BY_TYPE[self.type]
        if not self.id.startswith(expected):
            raise ValueError(f"ID prefix for type '{self.type}' must be '{expected}'")
        if len(self.source_steps) != len(self.source_step_ids):
            raise ValueError("source_steps and source_step_ids must have equal length")
        return self


class RequirementsDocument(BaseModel):
    model_config = ConfigDict(extra="forbid")

    requirements: List[Requirement] = Field(default_factory=list)
    source_file: str = "<inline>"
    source_feature: str = ""
    generated_at: str = Field(default_factory=lambda: datetime.now(timezone.utc).isoformat())
    provider: str = ""
    model: str = ""
    prompt_version: str = ""
    schema_version: str = "3.0"
    parse_method: str = "json"
    parse_errors: List[str] = Field(default_factory=list)
    parse_warnings: List[str] = Field(default_factory=list)

    def to_dict(self) -> dict:
        return self.model_dump(mode="json")

    def to_json(self, indent: int = 2) -> str:
        return self.model_dump_json(indent=indent)

    def traceability_matrix(self) -> List[dict]:
        rows: List[dict] = []
        for requirement in self.requirements:
            for index, location in enumerate(requirement.source_locations):
                rows.append({
                    "requirement_id": requirement.id,
                    "type": requirement.type,
                    "requirement": requirement.text,
                    "source_feature": requirement.source_feature,
                    "source_scenario": requirement.source_scenario,
                    "source_step_id": location.step_id,
                    "source_step": requirement.source_steps[index] if index < len(requirement.source_steps) else "",
                    "source_file": location.source_file,
                    "start_line": location.start_line,
                    "end_line": location.end_line,
                    "priority": requirement.priority,
                    "confidence": requirement.confidence,
                })
        return rows

    def to_markdown(self) -> str:
        lines = [
            "# System Requirements Specification",
            "",
            f"> Generated: {self.generated_at}",
            f"> Source file: {self.source_file}",
            f"> Source feature: {self.source_feature or 'N/A'}",
            f"> Model: {self.provider}/{self.model}" if self.provider else "> Model: N/A",
            f"> Prompt version: {self.prompt_version or 'N/A'}",
            f"> Schema version: {self.schema_version}",
            "",
        ]
        grouped: Dict[str, List[Requirement]] = {
            "functional": [],
            "non_functional": [],
            "security": [],
            "data": [],
            "business_rule": [],
        }
        for requirement in self.requirements:
            grouped[requirement.type].append(requirement)

        section_names = {
            "functional": "Functional Requirements",
            "non_functional": "Non-Functional Requirements",
            "security": "Security Requirements",
            "data": "Data Requirements",
            "business_rule": "Business Rules",
        }
        section_no = 1
        for req_type, heading in section_names.items():
            if not grouped[req_type]:
                continue
            lines.extend([f"## {section_no}. {heading}", ""])
            section_no += 1
            for requirement in grouped[req_type]:
                lines.extend([
                    f"### [{requirement.id}]",
                    requirement.text,
                    "",
                    f"- **Priority:** {requirement.priority}",
                    f"- **Confidence:** {requirement.confidence:.2f}",
                    f"- **Source feature:** {requirement.source_feature}",
                    f"- **Source scenario:** {requirement.source_scenario}",
                    "- **Source steps:**",
                ])
                for step_id, step_text, location in zip(
                    requirement.source_step_ids,
                    requirement.source_steps,
                    requirement.source_locations,
                ):
                    lines.append(
                        f"  - `{step_id}` — {step_text} "
                        f"({location.source_file}:{location.start_line}-{location.end_line})"
                    )
                lines.append("- **Acceptance criteria:**")
                for criterion in requirement.acceptance_criteria:
                    lines.append(f"  - {criterion}")
                if requirement.parameters:
                    lines.append(f"- **Parameters:** {', '.join(requirement.parameters)}")
                if requirement.warnings:
                    lines.append("- **Warnings:**")
                    for warning in requirement.warnings:
                        lines.append(f"  - {warning}")
                lines.append("")

        lines.extend([f"## {section_no}. Traceability Matrix", ""])
        lines.append("| Requirement | Scenario | Step ID | Source line |")
        lines.append("|---|---|---|---|")
        for row in self.traceability_matrix():
            lines.append(
                f"| {row['requirement_id']} | {row['source_scenario']} | "
                f"{row['source_step_id']} | {row['source_file']}:{row['start_line']}-{row['end_line']} |"
            )
        if self.parse_warnings:
            lines.extend(["", f"## {section_no + 1}. Parser Warnings", ""])
            lines.extend(f"- {warning}" for warning in self.parse_warnings)
        return "\n".join(lines).rstrip() + "\n"


def _extract_json_block(text: str) -> str:
    if not text or not text.strip():
        raise ValueError("LLM returned an empty response")
    fenced = re.search(r"```(?:json)?\s*([\s\S]*?)\s*```", text, flags=re.IGNORECASE)
    if fenced:
        return fenced.group(1).strip()
    start = text.find("{")
    end = text.rfind("}")
    if start >= 0 and end > start:
        return text[start:end + 1]
    return text.strip()


def _source_indexes(source_context: Optional[dict]) -> tuple[Dict[str, dict], Dict[str, List[dict]]]:
    by_id: Dict[str, dict] = {}
    by_text: Dict[str, List[dict]] = {}
    if not source_context:
        return by_id, by_text
    for scenario in source_context.get("scenarios", []):
        for step in scenario.get("steps", []):
            record = {
                **step,
                "scenario": scenario.get("name", ""),
                "source_file": source_context.get("source_file", "<inline>"),
            }
            by_id[step.get("id", "")] = record
            for value in (step.get("display_text", ""), step.get("text", "")):
                if value:
                    by_text.setdefault(_normalize(value), []).append(record)
    return by_id, by_text


def _resolve_sources(
    item: dict,
    source_context: Optional[dict],
) -> tuple[List[str], List[str], List[dict], str]:
    """Resolve trace references without hiding hallucinated source links.

    Every requested reference is preserved. Valid IDs/texts are normalized to
    their canonical source record; unresolved references receive a stable
    ``UNRESOLVED-*`` marker so fail-closed validation can reject the result.
    """
    by_id, by_text = _source_indexes(source_context)
    requested_ids = _as_list(item.get("source_step_ids"))
    requested_steps = _as_list(item.get("source_steps"))
    source_file = (source_context or {}).get("source_file", "<inline>")
    supplied_scenario = str(item.get("source_scenario") or "").strip()

    steps: List[str] = []
    ids: List[str] = []
    locations: List[dict] = []
    scenarios: List[str] = []
    used_ids: set[str] = set()

    def append_record(record: dict, fallback_text: str = "") -> None:
        step_id = str(record.get("id", "")).strip()
        if step_id in used_ids:
            return
        used_ids.add(step_id)
        text = str(record.get("display_text") or record.get("text") or fallback_text).strip()
        scenario = str(record.get("scenario") or supplied_scenario or "UNKNOWN").strip()
        start = int(record.get("start_line", 1) or 1)
        end = int(record.get("end_line", start) or start)
        ids.append(step_id)
        steps.append(text)
        scenarios.append(scenario)
        locations.append({
            "step_id": step_id,
            "source_file": record.get("source_file", source_file),
            "scenario": scenario,
            "start_line": start,
            "end_line": end,
        })

    def append_unresolved(index: int, step_id: str = "", step_text: str = "") -> None:
        unresolved_id = step_id.strip() or f"UNRESOLVED-{index:03d}"
        # Duplicate unresolved IDs should remain visible to validation.
        if unresolved_id in used_ids:
            unresolved_id = f"{unresolved_id}-DUP-{index:03d}"
        used_ids.add(unresolved_id)
        scenario = supplied_scenario or "UNKNOWN"
        ids.append(unresolved_id)
        steps.append(step_text.strip() or "UNRESOLVED SOURCE STEP")
        scenarios.append(scenario)
        locations.append({
            "step_id": unresolved_id,
            "source_file": source_file,
            "scenario": scenario,
            "start_line": 1,
            "end_line": 1,
        })

    # IDs are authoritative when supplied. Keep invalid IDs instead of silently
    # dropping them, pairing each with its corresponding source text when one
    # was returned by the model.
    for index, step_id in enumerate(requested_ids, 1):
        record = by_id.get(step_id)
        paired_text = requested_steps[index - 1] if index <= len(requested_steps) else ""
        if record is not None:
            append_record(record, paired_text)
        else:
            append_unresolved(index, step_id, paired_text)

    # Resolve source text entries not already paired with an ID. Exact and
    # unique matching is required; ambiguous text is intentionally unresolved.
    start_index = len(requested_ids)
    for offset, source_step in enumerate(requested_steps[start_index:], start_index + 1):
        matches = by_text.get(_normalize(source_step), [])
        if len(matches) == 1:
            append_record(matches[0], source_step)
        else:
            append_unresolved(offset, step_text=source_step)

    # Text-only traceability is also supported, with the same strict resolution.
    if not requested_ids and requested_steps:
        steps.clear(); ids.clear(); locations.clear(); scenarios.clear(); used_ids.clear()
        for index, source_step in enumerate(requested_steps, 1):
            matches = by_text.get(_normalize(source_step), [])
            if len(matches) == 1:
                append_record(matches[0], source_step)
            else:
                append_unresolved(index, step_text=source_step)

    scenario = supplied_scenario or (scenarios[0] if scenarios else "")

    if not ids:  # LLM hiç kaynak vermemiş — açıkça görünür bir placeholder bırak
        append_unresolved(1)
        scenario = supplied_scenario or "UNKNOWN"

    return steps, ids, locations, scenario
    

def _normalize_type(value: Any) -> str:
    normalized = str(value or "functional").strip().lower().replace("-", "_").replace(" ", "_")
    aliases = {
        "nonfunctional": "non_functional",
        "nfr": "non_functional",
        "functional_requirement": "functional",
        "security_requirement": "security",
        "data_requirement": "data",
        "businessrule": "business_rule",
    }
    return aliases.get(normalized, normalized)
def _fix_id_prefix(item: dict, seen_ids: set, type_counters: Dict[str, int]) -> None:
    """LLM'in ürettiği ID, type alanıyla uyuşmuyorsa otomatik düzeltir."""
    expected_prefix = _PREFIX_BY_TYPE[item["type"]]
    current_id = str(item.get("id", "")).strip()
    match = re.match(r"^[A-Za-z]+-(\d{3,})$", current_id)

    if current_id.startswith(expected_prefix) and current_id not in seen_ids:
        seen_ids.add(current_id)
        return

    number = match.group(1) if match else None
    candidate = f"{expected_prefix}{number}" if number else None

    if candidate is None or candidate in seen_ids:
        type_counters[item["type"]] = type_counters.get(item["type"], 0) + 1
        number = f"{type_counters[item['type']]:03d}"
        candidate = f"{expected_prefix}{number}"

    item["id"] = candidate
    seen_ids.add(candidate)

def parse_llm_output(
    llm_response: str,
    source_context: Optional[dict] = None,
    provider: str = "",
    model: str = "",
    prompt_version: str = "",
) -> RequirementsDocument:
    source_context = source_context or {}
    document = RequirementsDocument(
        source_file=source_context.get("source_file", "<inline>"),
        source_feature=source_context.get("feature", ""),
        provider=provider,
        model=model,
        prompt_version=prompt_version,
    )
    seen_ids: set = set()
    type_counters: Dict[str, int] = {}
    
    try:
        data = json.loads(_extract_json_block(llm_response))
    except (json.JSONDecodeError, ValueError) as exc:
        document.parse_method = "invalid_json"
        document.parse_errors.append(f"Valid JSON could not be parsed: {exc}")
        return document

    if not isinstance(data, dict) or not isinstance(data.get("requirements"), list):
        document.parse_errors.append("Top-level JSON must contain a 'requirements' array")
        return document

    for index, raw_item in enumerate(data["requirements"], 1):
        if not isinstance(raw_item, dict):
            document.parse_errors.append(f"Requirement #{index} is not a JSON object")
            continue
        item = dict(raw_item)
        item["type"] = _normalize_type(item.get("type"))
        source_steps, source_ids, source_locations, scenario = _resolve_sources(item, source_context)
        item["source_steps"] = source_steps
        item["source_step_ids"] = source_ids
        item["source_locations"] = source_locations
        item["source_feature"] = str(
            item.get("source_feature") or source_context.get("feature") or ""
        ).strip()
        item["source_scenario"] = scenario
        item["acceptance_criteria"] = _as_list(item.get("acceptance_criteria"))
        item["parameters"] = _as_list(item.get("parameters"))
        item["warnings"] = _as_list(item.get("warnings"))
        item["priority"] = str(item.get("priority") or "must").strip().lower()
        if item["priority"] == "won't":
            item["priority"] = "wont"
        _fix_id_prefix(item, seen_ids, type_counters)
        try:
            document.requirements.append(Requirement.model_validate(item))
        except ValidationError as exc:
            messages = "; ".join(
                f"{'.'.join(str(part) for part in error['loc'])}: {error['msg']}"
                for error in exc.errors()
            )
            document.parse_errors.append(f"Requirement #{index}: {messages}")
    return document


def _constants(text: str) -> set[str]:
    quoted = re.findall(r"['\"]([^'\"]+)['\"]", text)
    numbers = re.findall(r"\b\d+(?:\.\d+)?(?:\s*(?:ms|s|seconds?|minutes?|hours?|days?|%))?\b", text, flags=re.IGNORECASE)
    return {_normalize(value) for value in quoted + numbers if value.strip()}


def _quality_warnings(requirement: Requirement) -> List[str]:
    warnings: List[str] = []
    lower = requirement.text.casefold()
    ambiguous_terms = [
        "appropriate", "adequate", "quickly", "user-friendly", "as needed",
        "if possible", "etc.", "and/or", "sufficient", "reasonable",
    ]
    found = [term for term in ambiguous_terms if term in lower]
    if found:
        warnings.append("Potentially ambiguous wording: " + ", ".join(found))
    # Conjunction is a heuristic; warn instead of rejecting valid compound noun
    # phrases such as "username and password".
    if len(re.findall(r"\b(and|or)\b", lower)) >= 2:
        warnings.append("Requirement may contain more than one independently testable behavior")
    if requirement.confidence < 0.7:
        warnings.append("Low confidence requirement requires human review")
    if not any(token in lower for token in (
        "return", "display", "store", "reject", "allow", "prevent", "generate",
        "verify", "authorize", "record", "respond", "redirect", "calculate",
        "encrypt", "delete", "update", "create", "send", "receive", "grant", "deny", "be ",
    )):
        warnings.append("Testability is unclear; no observable system behavior was detected")
    return warnings


def validate_requirements_doc(
    document: RequirementsDocument,
    source_context: Optional[dict] = None,
) -> ValidationResult:
    errors = list(document.parse_errors)
    warnings = list(document.parse_warnings)
    source_context = source_context or {}
    by_id, by_text = _source_indexes(source_context)
    expected_feature = str(source_context.get("feature") or "").strip()
    known_scenarios = {
        _normalize(str(scenario.get("name") or ""))
        for scenario in source_context.get("scenarios", [])
        if str(scenario.get("name") or "").strip()
    }

    if not document.requirements:
        errors.append("At least one valid requirement is required")

    ids = [requirement.id for requirement in document.requirements]
    duplicates = [item for item, count in Counter(ids).items() if count > 1]
    if duplicates:
        errors.append("Duplicate requirement IDs: " + ", ".join(duplicates))

    for requirement in document.requirements:
        expected_prefix = _PREFIX_BY_TYPE[requirement.type]
        if not requirement.id.startswith(expected_prefix):
            errors.append(f"{requirement.id}: ID prefix does not match type {requirement.type}")

        if requirement.type == "non_functional":
            if not re.match(r"^The system (shall|must)\b", requirement.text, flags=re.IGNORECASE):
                errors.append(f"{requirement.id}: non-functional text must start with 'The system shall/must'")
        elif not re.match(r"^The system shall\b", requirement.text, flags=re.IGNORECASE):
            errors.append(f"{requirement.id}: text must start with 'The system shall'")

        if not requirement.source_steps or not requirement.source_step_ids:
            errors.append(f"{requirement.id}: at least one source step is mandatory")
        if len(requirement.source_steps) != len(requirement.source_step_ids):
            errors.append(f"{requirement.id}: source step texts and IDs are inconsistent")

        for step_id, step_text in zip(requirement.source_step_ids, requirement.source_steps):
            if by_id:
                if step_id not in by_id:
                    errors.append(f"{requirement.id}: unknown source step ID {step_id}")
                    continue
                source_record = by_id[step_id]
                valid_texts = {
                    _normalize(source_record.get("text", "")),
                    _normalize(source_record.get("display_text", "")),
                }
                if _normalize(step_text) not in valid_texts:
                    errors.append(f"{requirement.id}: source step text does not match {step_id}")

        if not requirement.source_feature or not requirement.source_scenario:
            errors.append(f"{requirement.id}: source feature and scenario are mandatory")
        if expected_feature and _normalize(requirement.source_feature) != _normalize(expected_feature):
            errors.append(
                f"{requirement.id}: source feature does not match parsed feature '{expected_feature}'"
            )
        if known_scenarios and _normalize(requirement.source_scenario) not in known_scenarios:
            errors.append(
                f"{requirement.id}: unknown source scenario '{requirement.source_scenario}'"
            )
        if not requirement.acceptance_criteria:
            errors.append(f"{requirement.id}: acceptance criteria are mandatory")

        if len(requirement.source_locations) != len(requirement.source_step_ids):
            errors.append(f"{requirement.id}: source locations and step IDs are inconsistent")
        for location, step_id in zip(requirement.source_locations, requirement.source_step_ids):
            if location.step_id != step_id:
                errors.append(f"{requirement.id}: source location step ID does not match {step_id}")
                continue
            canonical = by_id.get(step_id)
            if canonical:
                if location.start_line != int(canonical.get("start_line", 1) or 1):
                    errors.append(f"{requirement.id}: source start line does not match {step_id}")
                canonical_end = int(canonical.get("end_line", canonical.get("start_line", 1)) or 1)
                if location.end_line != canonical_end:
                    errors.append(f"{requirement.id}: source end line does not match {step_id}")
                if _normalize(location.scenario) != _normalize(str(canonical.get("scenario") or "")):
                    errors.append(f"{requirement.id}: source location scenario does not match {step_id}")

        warnings.extend(f"{requirement.id}: {warning}" for warning in requirement.warnings)
        source_constants = _constants(" ".join(requirement.source_steps))
        requirement_constants = _constants(requirement.text)
        invented = sorted(requirement_constants - source_constants)
        if invented:
            warnings.append(
                f"{requirement.id}: constants not found in traced steps: {', '.join(invented)}"
            )
        warnings.extend(f"{requirement.id}: {warning}" for warning in _quality_warnings(requirement))

    # Semantic duplicate check.
    for left_index, left in enumerate(document.requirements):
        for right in document.requirements[left_index + 1:]:
            similarity = SequenceMatcher(None, _normalize(left.text), _normalize(right.text)).ratio()
            if similarity >= 0.97:
                errors.append(f"Potential duplicate requirements: {left.id} and {right.id} ({similarity:.0%})")

            left_core = _normalize(re.sub(r"\bshall not\b", "shall", left.text, flags=re.IGNORECASE))
            right_core = _normalize(re.sub(r"\bshall not\b", "shall", right.text, flags=re.IGNORECASE))
            polarity_differs = ("shall not" in left.text.casefold()) != ("shall not" in right.text.casefold())
            if polarity_differs and SequenceMatcher(None, left_core, right_core).ratio() >= 0.85:
                warnings.append(f"Possible contradiction between {left.id} and {right.id}")

    metadata = {
        "requirement_count": len(document.requirements),
        "by_type": dict(Counter(requirement.type for requirement in document.requirements)),
        "has_duplicates": bool(duplicates),
        "has_traceability": bool(document.requirements) and all(
            requirement.source_step_ids for requirement in document.requirements
        ),
        "parse_method": document.parse_method,
        "schema_version": document.schema_version,
        "traceability_rows": len(document.traceability_matrix()),
        "quality_warning_count": len(warnings),
        "quality_score": max(0, 100 - (len(errors) * 25) - (len(warnings) * 5)),
    }
    return ValidationResult(
        valid=not errors,
        content=document.to_markdown() if document.requirements else "",
        errors=errors,
        warnings=warnings,
        metadata=metadata,
    )
