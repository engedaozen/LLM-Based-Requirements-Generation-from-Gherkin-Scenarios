"""Base interfaces for LLM providers."""
from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import asdict, dataclass
from typing import Any, Dict, Optional


@dataclass
class LLMResponse:
    text: str
    model: str
    provider: str
    tokens_used: Optional[int] = None
    latency_ms: Optional[float] = None
    success: bool = True
    error: Optional[str] = None
    usage: Optional[Dict[str, Any]] = None

    @property
    def content(self) -> str:
        return self.text

    def to_dict(self) -> dict:
        return asdict(self)


class BaseLLMAdapter(ABC):
    @property
    @abstractmethod
    def provider_name(self) -> str:
        raise NotImplementedError

    @property
    @abstractmethod
    def model_name(self) -> str:
        raise NotImplementedError

    @abstractmethod
    def generate(self, prompt: str, response_format: Optional[str] = None) -> LLMResponse:
        raise NotImplementedError

    @abstractmethod
    def is_available(self) -> bool:
        raise NotImplementedError

    def health_check(self) -> dict:
        return {
            "provider": self.provider_name,
            "model": self.model_name,
            "available": bool(self.is_available()),
        }
