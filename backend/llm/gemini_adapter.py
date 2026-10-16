"""Google Gemini adapter using the google-genai SDK."""
from __future__ import annotations

import os
import random
import time
from typing import List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field

from .base import BaseLLMAdapter, LLMResponse


class _GeneratedRequirement(BaseModel):
    
    id: str
    type: Literal["functional", "non_functional", "security", "data", "business_rule"]
    text: str
    source_feature: str
    source_scenario: str
    source_steps: List[str]
    source_step_ids: List[str]
    acceptance_criteria: List[str]
    parameters: List[str]
    priority: Literal["must", "should", "could", "wont"]
    confidence: float = Field(ge=0.0, le=1.0)
    warnings: List[str]


class _GeneratedRequirements(BaseModel):
    
    requirements: List[_GeneratedRequirement]


class GeminiAdapter(BaseLLMAdapter):
    def __init__(
        self,
        model: str = "gemini-3.6-flash",
        max_retries: int = 4,
        base_delay: float = 1.0,
        temperature: float = 0.0,
        **_kwargs,
    ):
        self._model = model
        self._max_retries = max_retries
        self._base_delay = base_delay
        self._temperature = temperature
        self._client = None

    @property
    def provider_name(self) -> str:
        return "gemini"

    @property
    def model_name(self) -> str:
        return self._model

    def is_available(self) -> bool:
        return bool(os.getenv("GEMINI_API_KEY", "").strip())

    def _get_client(self):
        if self._client is None:
            from google import genai
            api_key = os.getenv("GEMINI_API_KEY", "").strip()
            if not api_key:
                raise ValueError("GEMINI_API_KEY was not found")
            self._client = genai.Client(api_key=api_key)
        return self._client

    def generate(self, prompt: str, response_format: Optional[str] = None) -> LLMResponse:
        if not self.is_available():
            return LLMResponse("", self._model, self.provider_name, success=False, error="GEMINI_API_KEY was not found")

        started = time.perf_counter()
        for attempt in range(1, self._max_retries + 1):
            try:
                from google.genai import errors, types

                config_kwargs = {"temperature": self._temperature}
                if response_format == "json":
                    config_kwargs.update({
                        "response_mime_type": "application/json",
                        "response_schema": _GeneratedRequirements,
                    })
                
                    
                response = self._get_client().models.generate_content(
                    model=self._model,
                    contents=prompt,
                    config=types.GenerateContentConfig(**config_kwargs),
                )
                text = str(getattr(response, "text", "") or "").strip()
                if not text:
                    return LLMResponse("", self._model, self.provider_name, success=False, error="Gemini returned an empty response")
                usage_metadata = getattr(response, "usage_metadata", None)
                usage = None
                tokens = None
                if usage_metadata is not None:
                    usage = {
                        "prompt_token_count": getattr(usage_metadata, "prompt_token_count", None),
                        "candidates_token_count": getattr(usage_metadata, "candidates_token_count", None),
                        "total_token_count": getattr(usage_metadata, "total_token_count", None),
                    }
                    tokens = usage.get("total_token_count")
                return LLMResponse(
                    text=text,
                    model=self._model,
                    provider=self.provider_name,
                    tokens_used=tokens,
                    latency_ms=(time.perf_counter() - started) * 1000,
                    success=True,
                    usage=usage,
                )
            except Exception as exc:
                error_text = str(exc)
                retryable = "503" in error_text or "overloaded" in error_text.casefold() or "429" in error_text
                if retryable and attempt < self._max_retries:
                    time.sleep(self._base_delay * (2 ** (attempt - 1)) + random.uniform(0, 0.25))
                    continue
                return LLMResponse(
                    "", self._model, self.provider_name,
                    latency_ms=(time.perf_counter() - started) * 1000,
                    success=False,
                    error=f"Gemini API error: {error_text}",
                )
        return LLMResponse("", self._model, self.provider_name, success=False, error="Gemini retry limit reached")
