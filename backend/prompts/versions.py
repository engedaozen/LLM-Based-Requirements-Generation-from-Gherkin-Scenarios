"""Prompt version registry."""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Dict, List, Optional

from .templates import get_prompt


@dataclass(frozen=True)
class PromptVersion:
    version: str
    created_at: datetime
    description: str
    changes: List[str] = field(default_factory=list)
    deprecated: bool = False


PROMPT_VERSIONS: Dict[str, List[PromptVersion]] = {
    "requirements": [
        PromptVersion("1.0.0", datetime(2025, 1, 1, tzinfo=timezone.utc), "Initial prompt", ["Initial release"], True),
        PromptVersion("2.0.0", datetime(2026, 7, 1, tzinfo=timezone.utc), "JSON and basic traceability", ["JSON schema", "source steps"], True),
        PromptVersion("3.0.0", datetime(2026, 7, 10, tzinfo=timezone.utc), "Stable step IDs and prompt-injection boundary", ["step IDs", "strict schema", "untrusted input boundary"]),
    ],
    "testcases": [
        PromptVersion("1.0.0", datetime(2025, 1, 1, tzinfo=timezone.utc), "Initial prompt", ["Initial release"], True),
        PromptVersion("2.0.0", datetime(2026, 7, 10, tzinfo=timezone.utc), "Traceable coverage prompt", ["positive/negative/boundary coverage", "source evidence"]),
    ],
    "uml": [
        PromptVersion("1.0.0", datetime(2025, 1, 1, tzinfo=timezone.utc), "Initial PlantUML prompt", ["PlantUML"], True),
        PromptVersion("2.0.0", datetime(2026, 7, 10, tzinfo=timezone.utc), "Injection-safe PlantUML prompt", ["untrusted input boundary", "no unsupported components"]),
    ],
}


def get_latest_version(prompt_name: str) -> Optional[str]:
    try:
        return get_prompt(prompt_name).version
    except ValueError:
        return None


def get_version_history(prompt_name: str) -> List[PromptVersion]:
    return PROMPT_VERSIONS.get(prompt_name, [])
