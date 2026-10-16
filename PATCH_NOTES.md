# Patch Notes — 10 July 2026

This patch implements the security, parser, validation, traceability, testing, artifact-management and packaging recommendations from the project review.

## Critical fixes

1. Replaced string-prefix path checks with resolved-path containment checks.
2. Fixed `/api/parse-feature` to call the correct parser function and return the full structured feature model.
3. Fixed NVIDIA `is_available()` method compatibility and removed the unsafe Gemini-key fallback.
4. Changed requirement validation to fail closed on invalid/empty schemas, missing traceability, invalid IDs, invalid priorities/confidence and unknown source steps.
5. Made real LLM Behave tests opt-in and expanded mocks to satisfy three-test-case scenarios.

## Engineering additions

- Official Gherkin AST integration plus structured fallback.
- Stable step IDs and source lines.
- Pydantic schema with all traceability and acceptance fields.
- Prompt version in cache, logs and artifacts.
- Validated structured cache and atomic artifact storage.
- Quality checks for duplicates, possible contradictions, ambiguity, atomicity and testability.
- Artifact list/open/compare/regenerate/review APIs and frontend controls.
- JSON, Markdown, CSV, DOCX, XLSX, ReqIF and PlantUML exporters.
- Request-size limit, optional API key, same-origin static serving, security headers and rate limiting.
- Clean delivery package and automated tests.

## Final hardening pass

- Preserves invalid or hallucinated trace references instead of silently dropping them, so mixed valid/invalid source citations fail validation.
- Verifies feature names, scenario names, source line ranges and location-to-step consistency against the parsed Gherkin source model.
- Preserves and inherits both feature-level and rule-level Background steps.
- Uses a Pydantic structured-output schema for Gemini JSON generation in addition to post-generation validation.
- Produces a self-contained ReqIF 1.2 structure with declared datatypes, attributes, object/specification types and hierarchy.
- Adds Markdown and CSV controls to the artifact-management frontend.
