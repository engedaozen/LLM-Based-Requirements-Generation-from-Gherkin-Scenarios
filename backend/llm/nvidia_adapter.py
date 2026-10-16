"""NVIDIA NIM/OpenAI-compatible adapter."""
from __future__ import annotations

import os
import time
from typing import Optional

import requests

from .base import BaseLLMAdapter, LLMResponse


class NvidiaAdapter(BaseLLMAdapter):
    def __init__(
        self,
        model: str = "meta/llama-3.1-8b-instruct",
        timeout: int = 45,
        temperature: float = 0.0,
        **_kwargs,
    ):
        self._model = model
        # Never fall back to another provider's secret.
        self.api_key = os.getenv("NVIDIA_API_KEY", "").strip()
        self.base_url = os.getenv(
            "NVIDIA_API_URL",
            "https://integrate.api.nvidia.com/v1/chat/completions",
        )
        self.timeout = timeout
        self.temperature = temperature

    @property
    def provider_name(self) -> str:
        return "nvidia"

    @property
    def model_name(self) -> str:
        return self._model

    def is_available(self) -> bool:
        return bool(self.api_key)

    def generate(self, prompt: str, response_format: Optional[str] = None) -> LLMResponse:
        if not self.is_available():
            return LLMResponse("", self._model, self.provider_name, success=False, error="NVIDIA_API_KEY was not found")

        payload = {
            "model": self._model,
            "messages": [{"role": "user", "content": prompt}],
            "temperature": self.temperature,
            "max_tokens": 4096,
        }
        if response_format == "json":
            payload["response_format"] = {"type": "json_object"}

        started = time.perf_counter()
        try:
            response = requests.post(
                self.base_url,
                headers={
                    "Authorization": f"Bearer {self.api_key}",
                    "Content-Type": "application/json",
                },
                json=payload,
                timeout=self.timeout,
            )
            latency = (time.perf_counter() - started) * 1000
            if response.status_code != 200:
                detail = response.text[:500]
                return LLMResponse(
                    "", self._model, self.provider_name,
                    latency_ms=latency, success=False,
                    error=f"NVIDIA API error {response.status_code}: {detail}",
                )
            data = response.json()
            text = str(data.get("choices", [{}])[0].get("message", {}).get("content", "")).strip()
            if not text:
                return LLMResponse("", self._model, self.provider_name, latency_ms=latency, success=False, error="NVIDIA returned an empty response")
            usage = data.get("usage") or {}
            return LLMResponse(
                text=text,
                model=self._model,
                provider=self.provider_name,
                tokens_used=usage.get("total_tokens"),
                latency_ms=latency,
                success=True,
                usage=usage,
            )
        except requests.RequestException as exc:
            return LLMResponse(
                "", self._model, self.provider_name,
                latency_ms=(time.perf_counter() - started) * 1000,
                success=False,
                error=f"NVIDIA connection error: {exc}",
            )
