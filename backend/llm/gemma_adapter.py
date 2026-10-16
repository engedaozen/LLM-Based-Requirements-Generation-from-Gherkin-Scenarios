"""Hugging Face/locally hosted Gemma adapter."""
from __future__ import annotations

import os
import time
from typing import Optional

import requests

from .base import BaseLLMAdapter, LLMResponse


class GemmaAdapter(BaseLLMAdapter):
    def __init__(
        self,
        model: str = "google/gemma-2-9b-it",
        api_url: Optional[str] = None,
        timeout: int = 60,
        temperature: float = 0.0,
        **_kwargs,
    ):
        self._model = model
        self._api_url = api_url or os.getenv(
            "GEMMA_API_URL",
            f"https://api-inference.huggingface.co/models/{model}",
        )
        self.timeout = timeout
        self.temperature = temperature

    @property
    def provider_name(self) -> str:
        return "gemma"

    @property
    def model_name(self) -> str:
        return self._model

    def _get_api_key(self) -> str:
        return (os.getenv("HF_API_KEY") or os.getenv("HUGGINGFACE_API_KEY") or "").strip()

    def is_available(self) -> bool:
        return bool(self._get_api_key())

    def generate(self, prompt: str, response_format: Optional[str] = None) -> LLMResponse:
        if not self.is_available():
            return LLMResponse("", self._model, self.provider_name, success=False, error="HF_API_KEY was not found")
        started = time.perf_counter()
        try:
            response = requests.post(
                self._api_url,
                headers={
                    "Authorization": f"Bearer {self._get_api_key()}",
                    "Content-Type": "application/json",
                },
                json={
                    "inputs": prompt,
                    "parameters": {
                        "max_new_tokens": 4096,
                        "temperature": self.temperature,
                        "do_sample": self.temperature > 0,
                        "return_full_text": False,
                    },
                },
                timeout=self.timeout,
            )
            latency = (time.perf_counter() - started) * 1000
            if response.status_code != 200:
                return LLMResponse("", self._model, self.provider_name, latency_ms=latency, success=False, error=f"Gemma API error {response.status_code}: {response.text[:500]}")
            data = response.json()
            if isinstance(data, list) and data:
                text = data[0].get("generated_text", "")
            elif isinstance(data, dict):
                text = data.get("generated_text", "")
            else:
                text = ""
            text = str(text).strip()
            if not text:
                return LLMResponse("", self._model, self.provider_name, latency_ms=latency, success=False, error="Gemma returned an empty response")
            return LLMResponse(text, self._model, self.provider_name, latency_ms=latency, success=True)
        except requests.RequestException as exc:
            return LLMResponse("", self._model, self.provider_name, latency_ms=(time.perf_counter() - started) * 1000, success=False, error=f"Gemma connection error: {exc}")
