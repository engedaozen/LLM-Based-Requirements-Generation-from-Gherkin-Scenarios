"""Application configuration.

All paths are resolved from the project root so the application behaves the
same regardless of the current working directory.
"""
from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List


PROJECT_ROOT = Path(__file__).resolve().parents[1]

try:
    from dotenv import load_dotenv
    load_dotenv(PROJECT_ROOT / ".env", override=False)
except ImportError:
    # Configuration still works through process environment variables.
    pass


def _bool_env(name: str, default: bool = False) -> bool:
    value = os.getenv(name)
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "on"}


def _csv_env(name: str, default: str) -> List[str]:
    return [item.strip() for item in os.getenv(name, default).split(",") if item.strip()]


@dataclass(frozen=True)
class LLMConfig:
    provider: str
    model: str
    max_retries: int = 4
    base_delay: float = 1.0
    timeout: int = 45
    temperature: float = 0.0


@dataclass(frozen=True)
class AppConfig:
    debug: bool = False
    host: str = "127.0.0.1"
    port: int = 5000
    project_root: Path = PROJECT_ROOT
    features_dir: Path = PROJECT_ROOT / "features"
    outputs_dir: Path = PROJECT_ROOT / "outputs"
    logs_dir: Path = PROJECT_ROOT / "logs"
    frontend_dir: Path = PROJECT_ROOT / "frontend"
    max_content_length: int = 1_048_576  # 1 MiB
    allowed_origins: List[str] = field(default_factory=list)
    api_key: str = ""
    rate_limit_requests: int = 20
    rate_limit_window_seconds: int = 60
    store_source_inputs: bool = True
    active_llm: str = "gemini"
    llm_configs: Dict[str, LLMConfig] = field(default_factory=dict)

    def get_active_llm_config(self) -> LLMConfig:
        if self.active_llm not in self.llm_configs:
            available = ", ".join(sorted(self.llm_configs))
            raise ValueError(
                f"ACTIVE_LLM '{self.active_llm}' is not configured. Available: {available}"
            )
        return self.llm_configs[self.active_llm]


def load_config() -> AppConfig:
    default_origins = "http://localhost:5000,http://127.0.0.1:5000"
    llm_configs = {
        "gemini": LLMConfig(
            provider="gemini",
            model=os.getenv("GEMINI_MODEL", "gemini-3.6-flash"),
        ),
        "nvidia": LLMConfig(
            provider="nvidia",
            model=os.getenv("NVIDIA_MODEL", "meta/llama-3.1-8b-instruct"),
        ),
        "gemma": LLMConfig(
            provider="gemma",
            model=os.getenv("GEMMA_MODEL", "google/gemma-2-9b-it"),
        ),
    }
    return AppConfig(
        debug=_bool_env("FLASK_DEBUG", False),
        host=os.getenv("HOST", "127.0.0.1"),
        port=int(os.getenv("PORT", "5000")),
        max_content_length=int(os.getenv("MAX_CONTENT_LENGTH", "1048576")),
        allowed_origins=_csv_env("ALLOWED_ORIGINS", default_origins),
        api_key=os.getenv("APP_API_KEY", "").strip(),
        rate_limit_requests=max(1, int(os.getenv("RATE_LIMIT_REQUESTS", "20"))),
        rate_limit_window_seconds=max(1, int(os.getenv("RATE_LIMIT_WINDOW_SECONDS", "60"))),
        store_source_inputs=_bool_env("STORE_SOURCE_INPUTS", True),
        active_llm=os.getenv("ACTIVE_LLM", "gemini").strip().lower(),
        llm_configs=llm_configs,
    )


config = load_config()
