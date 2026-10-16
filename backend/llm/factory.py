"""LLM adapter registry and factory."""
from __future__ import annotations

from typing import Optional, Type

from .base import BaseLLMAdapter
from .gemini_adapter import GeminiAdapter
from .gemma_adapter import GemmaAdapter
from .nvidia_adapter import NvidiaAdapter

_ADAPTERS: dict[str, Type[BaseLLMAdapter]] = {
    "gemini": GeminiAdapter,
    "gemma": GemmaAdapter,
    "nvidia": NvidiaAdapter,
}


def get_llm_adapter(provider: str = "gemini", model: Optional[str] = None, **kwargs) -> BaseLLMAdapter:
    key = provider.strip().lower()
    if key not in _ADAPTERS:
        raise ValueError(f"Unknown LLM provider '{provider}'. Available: {', '.join(sorted(_ADAPTERS))}")
    if model:
        kwargs["model"] = model
    return _ADAPTERS[key](**kwargs)


def register_adapter(name: str, adapter_class: Type[BaseLLMAdapter]) -> None:
    if not issubclass(adapter_class, BaseLLMAdapter):
        raise TypeError("adapter_class must inherit BaseLLMAdapter")
    _ADAPTERS[name.strip().lower()] = adapter_class


def list_available_adapters() -> list[str]:
    return sorted(_ADAPTERS)
