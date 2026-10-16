from backend.parsers.gherkin_parser import build_source_context, extract_scenarios, parse_feature


def test_scenario_outline_examples_and_trace_lines():
    text = """Feature: Login
  Background: Common
    Given the service is available

  @smoke
  Scenario Outline: Valid login
    Given the user is on the login page
    When the user enters <role>
    Then access is granted

    Examples:
      | role |
      | Admin |
"""
    feature = parse_feature(text, "features/login.feature")
    assert feature.title == "Login"
    assert len(feature.scenarios) == 1
    scenario = feature.scenarios[0]
    assert scenario.keyword == "Scenario Outline"
    assert scenario.tags == ["@smoke"]
    assert scenario.examples[0].rows == [{"role": "Admin"}]
    assert scenario.steps[0].inherited is True
    context = build_source_context(text, "features/login.feature")
    assert context["scenarios"][0]["steps"][1]["id"].startswith("STEP-")
    assert context["scenarios"][0]["steps"][1]["start_line"] == 7


def test_turkish_gherkin_keywords():
    text = """# language: tr
Özellik: Giriş
  Senaryo: Başarılı giriş
    Diyelim ki kullanıcı giriş ekranındadır
    Eğer ki kullanıcı geçerli bilgi girer
    O zaman erişim sağlanır
"""
    feature = parse_feature(text, "features/giris.feature")
    assert feature.title == "Giriş"
    assert len(feature.scenarios) == 1
    assert len(feature.scenarios[0].steps) == 3


def test_embedded_feature_docstrings_are_deduplicated():
    inner = "Feature: Login (UC-B1)\n  Scenario: Flow\n    Given a\n    When b\n    Then c"
    outer = f'''Feature: Wrapper
@uc_b1 @requirement
Scenario: Requirements
  Given The BDD text to be analyzed is:
    """
{inner}
    """
@uc_b1 @testcase
Scenario: Tests
  Given The BDD text to be analyzed is:
    """
{inner}
    """
'''
    scenarios = extract_scenarios(outer, "features/wrapper.feature")
    assert len(scenarios) == 1
    assert scenarios[0]["id"] == "UC-B1"


def test_rule_background_is_inherited_and_preserved():
    text = """Feature: Payments
  Background: Global setup
    Given the service is online

  Rule: Refund policy
    Background: Refund setup
      Given a settled payment exists

    Scenario: Refund succeeds
      When the operator refunds the payment
      Then the refund is recorded
"""
    feature = parse_feature(text, "features/payments.feature")
    assert len(feature.rules) == 1
    assert feature.rules[0].background is not None
    scenario = feature.scenarios[0]
    assert [step.text for step in scenario.steps[:2]] == [
        "the service is online",
        "a settled payment exists",
    ]
    assert all(step.inherited for step in scenario.steps[:2])
