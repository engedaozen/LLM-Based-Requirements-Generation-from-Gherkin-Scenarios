# BDD-to-Requirements Generator v3.0

A Flask application that parses Gherkin/BDD scenarios into a structured source model and uses an LLM to generate validated, traceable requirements, test cases and PlantUML artifacts.

## What changed in v3.0

- Secure feature-file resolution with `Path.is_relative_to()`.
- Same-origin static frontend; arbitrary project files are no longer served.
- API-only CORS, optional API-key authentication, request-size limits and rate limiting.
- Official Gherkin parser integration with a deterministic structured fallback.
- Tags, rules, backgrounds, outlines, examples, doc strings, tables, languages, source lines and stable step IDs.
- Strict Pydantic requirement schema and fail-closed validation.
- Requirement-level traceability, quality warnings, duplicate and contradiction checks.
- Prompt-injection boundaries and provider-level JSON response mode where available.
- Prompt/model/version-aware validated cache.
- Managed artifacts with review status, comparison, regeneration and metadata.
- JSON, Markdown, CSV, Word, Excel, ReqIF and PlantUML exports.
- Deterministic mock Behave tests by default; real LLM tests are opt-in.
- Clean packaging: virtual environments, `.git`, logs, caches and generated outputs are excluded.

## Installation

Python 3.10 or newer is required.

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/macOS
source .venv/bin/activate

pip install -r requirements.txt
copy .env.example .env   # Windows
# cp .env.example .env   # Linux/macOS
```

Set one provider key in `.env`, for example:

```text
ACTIVE_LLM=gemini
GEMINI_API_KEY=...
```

For a production or shared-network deployment, also set:

```text
APP_API_KEY=a-long-random-secret
HOST=127.0.0.1
FLASK_DEBUG=0
```

Start the application:

```bash
python run.py
```

Open `http://127.0.0.1:5000`.

## Tests

Unit and API tests:

```bash
pytest
```

Deterministic Behave suite, without LLM calls:

```bash
behave
```

Optional real-provider integration run:

```bash
RUN_LLM_TESTS=1 behave
```

On Windows PowerShell:

```powershell
$env:RUN_LLM_TESTS="1"
behave
```

## Architecture

```text
BDD file/text
  -> Gherkin parser
  -> structured feature/scenario/step model
  -> stable source-step IDs and line ranges
  -> versioned LLM prompt
  -> strict JSON requirement objects
  -> schema + traceability + quality validation
  -> validated cache
  -> managed artifact repository
  -> Markdown / JSON / CSV / DOCX / XLSX / ReqIF / PlantUML
```

Key packages:

```text
backend/api/          HTTP request/response only
backend/services/     generation orchestration
backend/parsers/      Gherkin, requirement and output validation
backend/llm/          provider adapters
backend/prompts/      versioned prompts
backend/repository/   features, artifacts, logs and cache
backend/exporters/    artifact export formats
frontend/             same-origin web application
tests/                deterministic automated tests
```

## Security notes

- `/api/feature` and `/api/parse-feature` can only access `.feature` files under the configured `features` directory.
- The frontend is served only from `frontend/` by Flask's safe static handler.
- `APP_API_KEY` is optional for local development but should be set in production.
- LLM generation calls are rate limited per client process.
- Inputs have a configurable maximum size.
- Provider secrets are never reused across providers.
- The LLM prompt treats BDD input as untrusted data and requires source-step evidence.
- Only validated artifacts enter the cache.

The in-memory rate limiter is suitable for a single process. For multiple workers or distributed deployment, replace it with a shared Redis-backed gateway/limiter.

## Artifact API

- `GET /api/outputs` — list artifacts
- `GET /api/outputs/{id}` — open an artifact
- `POST /api/outputs/compare` — compare two artifacts
- `POST /api/outputs/{id}/regenerate` — regenerate from retained source
- `PATCH /api/outputs/{id}/review` — set `draft`, `reviewed`, `approved` or `rejected`
- `GET /api/outputs/{id}/export/{format}` — `json`, `md`, `csv`, `docx`, `xlsx`, `reqif`, `puml`

## Data retention

`STORE_SOURCE_INPUTS=true` enables artifact regeneration by retaining source BDD text in the local artifact record. Set it to `false` when source retention is not acceptable. Generated runtime data is stored under `outputs/` and `logs/`, both excluded from source packages.
