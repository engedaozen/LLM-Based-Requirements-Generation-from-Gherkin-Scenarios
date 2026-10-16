import json
import re

from backend.llm.base import BaseLLMAdapter, LLMResponse
from backend.repository.storage import CacheStorage, LogStorage, OutputStorage
from backend.services.generation_service import GenerationService


class FakeAdapter(BaseLLMAdapter):
    def __init__(self):
        self.calls = 0

    @property
    def provider_name(self):
        return "mock"

    @property
    def model_name(self):
        return "mock-model"

    def is_available(self):
        return True

    def generate(self, prompt, response_format=None):
        self.calls += 1
        match = re.search(r"BEGIN_UNTRUSTED_BDD_JSON\n(.*?)\nEND_UNTRUSTED_BDD_JSON", prompt, re.DOTALL)
        context = json.loads(match.group(1))
        scenario = context["scenarios"][0]
        step = scenario["steps"][-1]
        payload = {
            "requirements": [{
                "id": "FR-001",
                "type": "functional",
                "text": "The system shall grant access.",
                "source_feature": context["feature"],
                "source_scenario": scenario["name"],
                "source_steps": [step["display_text"]],
                "source_step_ids": [step["id"]],
                "acceptance_criteria": ["The documented access result occurs."],
                "parameters": [],
                "priority": "must",
                "confidence": 0.95,
                "warnings": [],
            }]
        }
        return LLMResponse(json.dumps(payload), self.model_name, self.provider_name)


def test_generation_validates_saves_and_uses_cache(tmp_path):
    adapter = FakeAdapter()
    service = GenerationService(
        adapter=adapter,
        output_storage=OutputStorage(tmp_path / "outputs"),
        log_storage=LogStorage(tmp_path / "logs"),
        cache_storage=CacheStorage(tmp_path / "cache"),
        use_cache=True,
        auto_save=True,
    )
    bdd = "Feature: Login\n  Scenario: Valid\n    Given user is ready\n    When credentials are valid\n    Then the system grants access"
    first = service.generate_requirements(bdd, "features/login.feature")
    second = service.generate_requirements(bdd, "features/login.feature")
    assert first.success, first.error
    assert first.artifact_id
    assert second.success and second.from_cache
    assert adapter.calls == 1
