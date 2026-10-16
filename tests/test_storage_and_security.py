from pathlib import Path

import pytest

from backend.repository.storage import CacheStorage, FeatureRepository, OutputStorage


def test_feature_repository_blocks_sibling_prefix(tmp_path):
    features = tmp_path / "features"
    evil = tmp_path / "features_evil"
    features.mkdir()
    evil.mkdir()
    (features / "ok.feature").write_text("Feature: OK", encoding="utf-8")
    (evil / "secret.feature").write_text("secret", encoding="utf-8")
    repo = FeatureRepository(features)
    assert repo.resolve("features/ok.feature").name == "ok.feature"
    with pytest.raises(ValueError):
        repo.resolve("../features_evil/secret.feature")


def test_cache_key_includes_prompt_version(tmp_path):
    cache = CacheStorage(tmp_path / "cache")
    valid = {"valid": True, "errors": [], "warnings": [], "metadata": {}}
    cache.set("input", "requirements", "mock", "model", "1.0", content="old", structured_data={}, validation=valid, artifact_id=None)
    assert cache.get("input", "requirements", "mock", "model", "1.0")["content"] == "old"
    assert cache.get("input", "requirements", "mock", "model", "2.0") is None


def test_artifact_review_compare_and_safe_ids(tmp_path):
    storage = OutputStorage(tmp_path / "outputs")
    validation = {"valid": True, "errors": [], "warnings": [], "metadata": {}}
    one = storage.save_artifact(output_type="requirements", content="one", structured_data={"requirements": []}, source_text="x", source_context={}, provider="mock", model="mock", prompt_version="1", validation=validation)
    two = storage.save_artifact(output_type="requirements", content="two", structured_data={"requirements": []}, source_text="x", source_context={}, provider="mock", model="mock", prompt_version="1", validation=validation)
    assert not storage.compare(one.id, two.id)["same"]
    assert storage.update_review(one.id, "approved", "ok").status == "approved"
    with pytest.raises(ValueError):
        storage.get_artifact("../bad")
