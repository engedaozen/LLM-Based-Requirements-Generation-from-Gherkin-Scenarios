"""Validation helpers for generated test cases and PlantUML."""
from __future__ import annotations

import re
from dataclasses import asdict, dataclass, field
from typing import Any, Dict, List


@dataclass
class ValidationResult:
    valid: bool
    content: str
    errors: List[str] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self, include_content: bool = True) -> dict:
        payload = asdict(self)
        if not include_content:
            payload.pop("content", None)
        return payload


_TESTCASE_HEADING = re.compile(r"(?im)^#{1,6}\s*(TC-\d{3,})\s*:\s*(.+?)\s*$")


def validate_testcases(text: str) -> ValidationResult:
    if not text or not text.strip():
        return ValidationResult(False, "", errors=["Empty test-case output"])

    content = text.strip()
    headings = list(_TESTCASE_HEADING.finditer(content))
    errors: List[str] = []
    warnings: List[str] = []
    ids = [match.group(1) for match in headings]

    if not headings:
        errors.append("No test case heading in '### TC-001: Name' format was found")
    if len(ids) != len(set(ids)):
        errors.append("Duplicate test case IDs were found")

    testcases: List[dict] = []
    for index, match in enumerate(headings):
        start = match.end()
        end = headings[index + 1].start() if index + 1 < len(headings) else len(content)
        body = content[start:end]
        tc_id = match.group(1)
        missing = []
        for label in ("Preconditions", "Steps", "Expected Result"):
            if not re.search(rf"(?im)^\s*{re.escape(label)}\s*:", body):
                missing.append(label)
        if missing:
            errors.append(f"{tc_id}: missing sections: {', '.join(missing)}")
        steps_match = re.search(
            r"(?ims)^\s*Steps\s*:\s*(.*?)(?=^\s*Expected Result\s*:|\Z)", body
        )
        if steps_match and not re.search(r"\b(?:1[.)]|- )", steps_match.group(1)):
            warnings.append(f"{tc_id}: steps are not clearly enumerated")
        expected_match = re.search(r"(?ims)^\s*Expected Result\s*:\s*(.*)$", body)
        if expected_match and not expected_match.group(1).strip():
            errors.append(f"{tc_id}: Expected Result is empty")
        testcases.append({"id": tc_id, "name": match.group(2).strip()})

    if len(headings) < 3:
        warnings.append("Fewer than three test cases were generated; negative/boundary coverage may be insufficient")

    return ValidationResult(
        valid=not errors,
        content=content,
        errors=errors,
        warnings=warnings,
        metadata={
            "tc_count": len(headings),
            "testcases": testcases,
            "has_duplicates": len(ids) != len(set(ids)),
        },
    )


def validate_plantuml(text: str) -> ValidationResult:
    if not text or not text.strip():
        return ValidationResult(False, "", errors=["Empty PlantUML output"])

    raw = text.strip()
    if raw.lower().startswith("error"):
        return ValidationResult(False, raw, errors=["The LLM returned an error message"])

    normalized = re.sub(r"^```(?:plantuml|puml)?\s*", "", raw, flags=re.IGNORECASE)
    normalized = re.sub(r"\s*```$", "", normalized).strip()
    errors: List[str] = []
    warnings: List[str] = []

    if normalized.count("@startuml") != 1:
        errors.append("PlantUML must contain exactly one @startuml")
    if normalized.count("@enduml") != 1:
        errors.append("PlantUML must contain exactly one @enduml")
    if "@startuml" in normalized and "@enduml" in normalized:
        if normalized.index("@startuml") > normalized.index("@enduml"):
            errors.append("@enduml occurs before @startuml")

    # Lightweight structural checks. They catch the most common malformed LLM
    # outputs without requiring a Java/PlantUML runtime in the web process.
    lower_lines = [line.strip().lower() for line in normalized.splitlines()]
    pair_rules = [
        (("if ", "if("), "endif", "if/endif"),
        (("alt ", "opt ", "loop ", "par ", "group ", "critical "), "end", "sequence block/end"),
        (("partition ",), "}", "partition braces"),
    ]
    if_count = sum(1 for line in lower_lines if line.startswith(("if ", "if(")))
    endif_count = sum(1 for line in lower_lines if line == "endif")
    if if_count != endif_count:
        errors.append(f"Unbalanced if/endif blocks ({if_count}/{endif_count})")

    opening_braces = normalized.count("{")
    closing_braces = normalized.count("}")
    if opening_braces != closing_braces:
        errors.append(f"Unbalanced braces ({opening_braces}/{closing_braces})")

    sequence_open = sum(
        1 for line in lower_lines
        if line.startswith(("alt ", "opt ", "loop ", "par ", "group ", "critical "))
    )
    sequence_end = sum(1 for line in lower_lines if line == "end")
    if sequence_open and sequence_end < sequence_open:
        errors.append("One or more sequence blocks are missing 'end'")

    meaningful = [
        line for line in lower_lines
        if line and not line.startswith("'") and line not in {"@startuml", "@enduml"}
    ]
    if len(meaningful) < 2:
        errors.append("PlantUML body does not contain a meaningful diagram")

    diagram_type = "Unknown"
    joined = "\n".join(lower_lines)
    if "usecase" in joined or re.search(r"(?m)^actor\s", joined):
        diagram_type = "Use Case"
    if re.search(r"[-.]+>|<[-.]+", normalized):
        diagram_type = "Sequence"
    if re.search(r"(?m)^\s*(abstract\s+)?class\s", normalized, flags=re.IGNORECASE):
        diagram_type = "Class"
    if "[*]" in normalized or re.search(r"(?m)^\s*state\s", normalized, flags=re.IGNORECASE):
        diagram_type = "State"
    if re.search(r"(?m)^\s*start\s*$", normalized, flags=re.IGNORECASE):
        diagram_type = "Activity"

    final_content = f"```plantuml\n{normalized}\n```"
    return ValidationResult(
        valid=not errors,
        content=final_content,
        errors=errors,
        warnings=warnings,
        metadata={"diagram_type": diagram_type, "line_count": len(normalized.splitlines())},
    )
