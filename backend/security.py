"""Small dependency-free API security helpers."""
from __future__ import annotations

import hmac
import threading
import time
from collections import defaultdict, deque
from typing import Deque, Dict

from flask import Flask, jsonify, request

from backend.config import AppConfig


class SlidingWindowRateLimiter:
    def __init__(self, requests_per_window: int, window_seconds: int):
        self.limit = requests_per_window
        self.window = window_seconds
        self._events: Dict[str, Deque[float]] = defaultdict(deque)
        self._lock = threading.Lock()

    def allow(self, key: str) -> tuple[bool, int]:
        now = time.monotonic()
        cutoff = now - self.window
        with self._lock:
            queue = self._events[key]
            while queue and queue[0] <= cutoff:
                queue.popleft()
            if len(queue) >= self.limit:
                retry_after = max(1, int(self.window - (now - queue[0])))
                return False, retry_after
            queue.append(now)
            return True, 0


def _provided_api_key() -> str:
    direct = request.headers.get("X-API-Key", "").strip()
    if direct:
        return direct
    authorization = request.headers.get("Authorization", "")
    if authorization.lower().startswith("bearer "):
        return authorization[7:].strip()
    return ""


def init_security(app: Flask, app_config: AppConfig) -> None:
    limiter = SlidingWindowRateLimiter(
        app_config.rate_limit_requests,
        app_config.rate_limit_window_seconds,
    )

    @app.before_request
    def protect_api():
        if not request.path.startswith("/api/"):
            return None

        # Optional shared-key protection. When APP_API_KEY is empty, local
        # development remains frictionless. Production should always set it.
        if app_config.api_key:
            provided = _provided_api_key()
            if not provided or not hmac.compare_digest(provided, app_config.api_key):
                return jsonify({"success": False, "error": "Unauthorized"}), 401

        if request.path == "/api/generate" and request.method == "POST":
            client_key = request.remote_addr or "unknown"
            allowed, retry_after = limiter.allow(client_key)
            if not allowed:
                response = jsonify({
                    "success": False,
                    "error": "Rate limit exceeded",
                    "retry_after_seconds": retry_after,
                })
                response.status_code = 429
                response.headers["Retry-After"] = str(retry_after)
                return response
        return None
