"""These tests run after installing requirements.txt."""
import pytest

flask = pytest.importorskip("flask")

from backend.app import create_app


def test_static_python_files_are_not_exposed():
    client = create_app().test_client()
    response = client.get("/backend/config.py")
    assert response.status_code == 404


def test_health_is_usable_without_provider_key():
    client = create_app().test_client()
    response = client.get("/api/health")
    assert response.status_code == 200
    payload = response.get_json()
    assert payload["success"] is True
    assert isinstance(payload["health"]["llm"]["available"], bool)
