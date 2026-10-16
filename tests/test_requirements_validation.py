import json

from backend.parsers import build_source_context
from backend.parsers.requirements_parser import parse_llm_output, validate_requirements_doc


BDD = """Feature: Login
  Scenario: Valid login
    Given the user is on the login page
    When the user enters valid credentials
    Then the system grants access
"""


def valid_payload(context):
    steps = context["scenarios"][0]["steps"]
    return {
        "requirements": [{
            "id": "FR-001",
            "type": "functional",
            "text": "The system shall grant access after valid credentials are entered.",
            "source_feature": "Login",
            "source_scenario": "Valid login",
            "source_steps": [steps[1]["display_text"], steps[2]["display_text"]],
            "source_step_ids": [steps[1]["id"], steps[2]["id"]],
            "acceptance_criteria": ["Valid credentials result in granted access."],
            "parameters": [],
            "priority": "must",
            "confidence": 0.95,
            "warnings": [],
        }]
    }


def test_valid_requirement_is_structured_and_traceable():
    context = build_source_context(BDD, "features/login.feature")
    document = parse_llm_output(json.dumps(valid_payload(context)), context, "mock", "mock", "3.0.0")
    result = validate_requirements_doc(document, context)
    assert result.valid, result.errors
    assert result.metadata["traceability_rows"] == 2
    assert document.requirements[0].source_locations[0].start_line == 4


def test_empty_document_fails_closed():
    context = build_source_context(BDD, "features/login.feature")
    document = parse_llm_output('{"requirements": []}', context)
    result = validate_requirements_doc(document, context)
    assert not result.valid
    assert "At least one valid requirement is required" in result.errors


def test_unknown_step_id_is_rejected():
    context = build_source_context(BDD, "features/login.feature")
    payload = valid_payload(context)
    payload["requirements"][0]["source_step_ids"] = ["STEP-UNKNOWN00001"]
    payload["requirements"][0]["source_steps"] = ["Then imaginary behavior"]
    document = parse_llm_output(json.dumps(payload), context)
    result = validate_requirements_doc(document, context)
    assert not result.valid


def test_invalid_confidence_and_id_do_not_enter_document():
    context = build_source_context(BDD, "features/login.feature")
    payload = valid_payload(context)
    payload["requirements"][0]["id"] = "BAD"
    payload["requirements"][0]["confidence"] = 2.5
    document = parse_llm_output(json.dumps(payload), context)
    assert document.parse_errors
    result = validate_requirements_doc(document, context)
    assert not result.valid


def test_mixed_valid_and_hallucinated_step_ids_fail_closed():
    context = build_source_context(BDD, "features/login.feature")
    payload = valid_payload(context)
    requirement = payload["requirements"][0]
    requirement["source_step_ids"].append("STEP-HALLUCINATED")
    requirement["source_steps"].append("Then an undocumented audit module runs")
    document = parse_llm_output(json.dumps(payload), context)
    result = validate_requirements_doc(document, context)
    assert not result.valid
    assert any("unknown source step ID STEP-HALLUCINATED" in error for error in result.errors)


def test_wrong_feature_or_scenario_is_rejected():
    context = build_source_context(BDD, "features/login.feature")
    payload = valid_payload(context)
    payload["requirements"][0]["source_feature"] = "Invented Feature"
    payload["requirements"][0]["source_scenario"] = "Invented Scenario"
    document = parse_llm_output(json.dumps(payload), context)
    result = validate_requirements_doc(document, context)
    assert not result.valid
    assert any("source feature does not match" in error for error in result.errors)
    assert any("unknown source scenario" in error for error in result.errors)
