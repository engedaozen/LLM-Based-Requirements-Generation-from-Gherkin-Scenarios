#!/usr/bin/env python3
"""BDD-to-Requirements application runner."""
from backend.app import create_app
from backend.config import config


def main() -> None:
    print("=" * 64)
    print("BDD to Requirements Generator v3.0")
    print(f"LLM provider : {config.active_llm}")
    print(f"Debug        : {config.debug}")
    print(f"Listen       : http://{config.host}:{config.port}")
    print("=" * 64)
    create_app().run(host=config.host, port=config.port, debug=config.debug)


if __name__ == "__main__":
    main()
