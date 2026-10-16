"""Flask application factory."""
from __future__ import annotations

from flask import Flask, jsonify
from flask_cors import CORS
from werkzeug.exceptions import RequestEntityTooLarge

from backend.api import api_blueprint
from backend.config import config
from backend.security import init_security


def create_app() -> Flask:
    app = Flask(
        __name__,
        static_folder=str(config.frontend_dir),
        static_url_path="",
    )
    app.config.update(
        MAX_CONTENT_LENGTH=config.max_content_length,
        JSON_SORT_KEYS=False,
    )

    CORS(
        app,
        resources={r"/api/*": {"origins": config.allowed_origins}},
        supports_credentials=False,
        methods=["GET", "POST", "PATCH", "OPTIONS"],
        allow_headers=["Content-Type", "Authorization", "X-API-Key"],
    )

    init_security(app, config)
    app.register_blueprint(api_blueprint)

    @app.get("/")
    def index():
        return app.send_static_file("index.html")

    @app.errorhandler(RequestEntityTooLarge)
    def too_large(_error):
        return jsonify({
            "success": False,
            "error": f"Request body exceeds {config.max_content_length} bytes",
        }), 413

    @app.errorhandler(404)
    def not_found(_error):
        # Do not expose arbitrary project files. Flask serves only files under
        # frontend_dir through its safe static-file handler.
        return jsonify({"success": False, "error": "Not found"}), 404

    @app.after_request
    def security_headers(response):
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "DENY")
        response.headers.setdefault("Referrer-Policy", "no-referrer")
        response.headers.setdefault(
            "Content-Security-Policy",
            "default-src 'self'; script-src 'self' 'unsafe-inline'; "
            "style-src 'self' 'unsafe-inline'; img-src 'self' data:; "
            "connect-src 'self'; frame-ancestors 'none'",
        )
        response.headers.setdefault("Cache-Control", "no-store")
        return response

    return app


if __name__ == "__main__":
    create_app().run(host=config.host, port=config.port, debug=config.debug)
