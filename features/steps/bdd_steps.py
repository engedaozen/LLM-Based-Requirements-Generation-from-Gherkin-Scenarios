"""Behave step definitions.

Real LLM calls are opt-in with RUN_LLM_TESTS=1. The default deterministic
suite uses mock responses and does not consume quota.
"""
from __future__ import annotations

import json
import os
import re
import traceback
from pathlib import Path

from behave import given, then, when

from bdd_core import generate_requirements, generate_testcases, generate_uml_plantuml
from backend.config import config

RUN_LLM_TESTS = os.getenv("RUN_LLM_TESTS", "0") == "1"
USE_MOCK_LLM = not RUN_LLM_TESTS

MOCK_RESPONSES = {
    "REQUIREMENTS": json.dumps({
        "requirements": [
            {
                "id": "FR-001",
                "type": "functional",
                "text": "The system shall authenticate a user with valid credentials.",
                "source_feature": "User Authentication",
                "source_scenario": "Successful Login",
                "source_steps": ["Given the user is on the login page"],
                "source_step_ids": ["STEP-000000000001"],
                "acceptance_criteria": ["Valid credentials result in authenticated access."],
                "parameters": [],
                "priority": "must",
                "confidence": 0.95,
                "warnings": [],
            },
            {
                "id": "FR-002",
                "type": "functional",
                "text": "The system shall reject invalid credentials.",
                "source_feature": "User Authentication",
                "source_scenario": "Failed Login",
                "source_steps": ["When the user enters invalid credentials"],
                "source_step_ids": ["STEP-000000000002"],
                "acceptance_criteria": ["Invalid credentials do not create an authenticated session."],
                "parameters": [],
                "priority": "must",
                "confidence": 0.95,
                "warnings": [],
            },
        ]
    }, indent=2),
    "TESTCASES": """### TC-001: Positive flow
Preconditions: Valid test data exists
Source Steps: Given/When/Then source
Steps:
1. Execute the valid flow
Expected Result: The documented success result occurs

### TC-002: Invalid input
Preconditions: Invalid test data exists
Source Steps: Exception-flow source
Steps:
1. Execute the invalid flow
Expected Result: The documented error result occurs

### TC-003: Boundary condition
Preconditions: Boundary test data exists
Source Steps: Limit-related source
Steps:
1. Execute the boundary flow
Expected Result: The documented boundary behavior occurs""",
    "UML": """```plantuml
@startuml
actor User
User -> System: Request
System --> User: Result
@enduml
```""",
}


def _run_ai_step(context, function, *args, label: str) -> None:
    try:
        if USE_MOCK_LLM:
            result = MOCK_RESPONSES[label.split("-")[0]]
        else:
            result = function(*args)
        context.output_text = str(result or "")
    except Exception:
        context.output_text = "ERROR:\n" + traceback.format_exc()
        raise


@given("The BDD text to be analyzed is:")
def step_read_bdd(context):
    context.input_text = (context.text or "").strip()


@when("AI analyzes the BDD scenario and generates system requirements")
def step_generate_requirements(context):
    _run_ai_step(context, generate_requirements, context.input_text, label="REQUIREMENTS")


@when("AI extracts detailed test cases from the BDD scenario")
def step_generate_testcases(context):
    _run_ai_step(context, generate_testcases, context.input_text, label="TESTCASES")


@when('AI generates a "{diagram_type}" from the BDD scenario')
def step_generate_uml(context, diagram_type):
    _run_ai_step(
        context,
        generate_uml_plantuml,
        context.input_text,
        diagram_type,
        label=f"UML-{diagram_type}",
    )


@then('The output should be saved as "{filename}"')
def step_save_output(context, filename):
    output_dir = config.outputs_dir / "behave"
    output_dir.mkdir(parents=True, exist_ok=True)
    safe_filename = Path(filename).name
    (output_dir / safe_filename).write_text(context.output_text, encoding="utf-8")


@then('The file should contain at least "{min_count}" Test Cases (TC)')
def step_check_min_testcases(context, min_count):
    count = len(set(re.findall(r"\bTC-\d{3,}\b", context.output_text or "")))
    assert count >= int(min_count), f"Expected >= {min_count} test cases, found {count}"


@then('The file should contain at least "{min_count}" Functional Requirement (FR)')
def step_check_min_requirements(context, min_count):
    text = context.output_text or ""
    ids = set(re.findall(r"\bFR-\d{3,}\b", text))
    assert len(ids) >= int(min_count), f"Expected >= {min_count} FRs, found {len(ids)}"


@then("The file should contain valid PlantUML code")
def step_check_plantuml(context):
    text = (context.output_text or "").replace("```plantuml", "").replace("```", "")
    assert text.count("@startuml") == 1, "Expected exactly one @startuml"
    assert text.count("@enduml") == 1, "Expected exactly one @enduml"
