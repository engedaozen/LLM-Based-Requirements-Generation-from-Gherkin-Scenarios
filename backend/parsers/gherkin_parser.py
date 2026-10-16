"""Gherkin parsing and source-model utilities.

The parser first tries the official ``gherkin-official`` AST implementation.
A deterministic native fallback is retained so the project can still inspect
features when the optional parser dependency has not yet been installed.

Both paths preserve tags, rules, backgrounds, scenario outlines, examples,
doc strings, data tables, source lines and stable step identifiers.
"""
from __future__ import annotations

import hashlib
import re
from dataclasses import asdict, dataclass, field
from typing import Any, Dict, Iterable, List, Optional, Sequence


@dataclass
class Step:
    id: str
    keyword: str
    text: str
    line_number: int
    end_line: int
    doc_string: Optional[str] = None
    data_table: List[List[str]] = field(default_factory=list)
    inherited: bool = False

    def display_text(self) -> str:
        return f"{self.keyword.strip()} {self.text}".strip()


@dataclass
class ExampleSet:
    name: str = ""
    tags: List[str] = field(default_factory=list)
    headers: List[str] = field(default_factory=list)
    rows: List[Dict[str, str]] = field(default_factory=list)
    start_line: int = 0
    end_line: int = 0


@dataclass
class Scenario:
    title: str
    keyword: str
    steps: List[Step] = field(default_factory=list)
    tags: List[str] = field(default_factory=list)
    examples: List[ExampleSet] = field(default_factory=list)
    description: str = ""
    rule: Optional[str] = None
    start_line: int = 0
    end_line: int = 0
    block_text: str = ""


@dataclass
class Rule:
    title: str
    tags: List[str] = field(default_factory=list)
    description: str = ""
    background: Optional[Scenario] = None
    start_line: int = 0
    end_line: int = 0


@dataclass
class Feature:
    title: str
    language: str = "en"
    description: str = ""
    scenarios: List[Scenario] = field(default_factory=list)
    background: Optional[Scenario] = None
    rules: List[Rule] = field(default_factory=list)
    tags: List[str] = field(default_factory=list)
    filename: str = "<inline>"
    start_line: int = 1
    end_line: int = 0
    raw_text: str = ""
    parser: str = "native"

    def to_dict(self) -> dict:
        return asdict(self)


_LANGUAGE_KEYWORDS: Dict[str, Dict[str, Sequence[str]]] = {
    "en": {
        "feature": ("Feature",),
        "rule": ("Rule",),
        "background": ("Background",),
        "scenario_outline": ("Scenario Outline", "Scenario Template"),
        "scenario": ("Scenario", "Example"),
        "examples": ("Examples", "Scenarios"),
        "given": ("Given",),
        "when": ("When",),
        "then": ("Then",),
        "and": ("And",),
        "but": ("But",),
    },
    "tr": {
        "feature": ("Özellik", "Ozellik"),
        "rule": ("Kural",),
        "background": ("Geçmiş", "Gecmis", "Arka Plan"),
        "scenario_outline": ("Senaryo taslağı", "Senaryo taslagi", "Senaryo Şablonu", "Senaryo Sablonu"),
        "scenario": ("Senaryo", "Örnek", "Ornek"),
        "examples": ("Örnekler", "Ornekler"),
        "given": ("Diyelim ki", "Verilen"),
        "when": ("Eğer ki", "Eger ki", "Ne zaman"),
        "then": ("O zaman",),
        "and": ("Ve",),
        "but": ("Fakat", "Ama"),
    },
}


def _step_id(filename: str, line: int, keyword: str, text: str) -> str:
    raw = f"{filename}|{line}|{keyword.strip()}|{text.strip()}"
    return "STEP-" + hashlib.sha1(raw.encode("utf-8")).hexdigest()[:12].upper()


def _split_tags(text: str) -> List[str]:
    return [token for token in text.split() if token.startswith("@")]


def _table_cells(line: str) -> List[str]:
    return [cell.strip().replace("\\|", "|") for cell in line.strip().strip("|").split("|")]


def _line_keyword(stripped: str, keywords: Sequence[str]) -> Optional[tuple[str, str]]:
    for keyword in sorted(keywords, key=len, reverse=True):
        match = re.match(rf"^{re.escape(keyword)}\s*:\s*(.*)$", stripped, flags=re.IGNORECASE)
        if match:
            return keyword, match.group(1).strip()
    return None


def _step_keyword(stripped: str, keyword_map: Dict[str, Sequence[str]]) -> Optional[tuple[str, str]]:
    for role in ("given", "when", "then", "and", "but"):
        for keyword in sorted(keyword_map[role], key=len, reverse=True):
            match = re.match(rf"^{re.escape(keyword)}(?:\s+|$)(.*)$", stripped, flags=re.IGNORECASE)
            if match:
                return keyword, match.group(1).strip()
    return None


class GherkinParser:
    def parse(self, text: str, filename: str = "<inline>") -> Feature:
        try:
            parsed = self._parse_official(text, filename)
            if parsed.title or parsed.scenarios:
                return parsed
        except Exception:
            # The native parser is deliberate, not a regex-only frontend
            # fallback. It preserves the same source model and is covered by
            # unit tests.
            pass
        return self._parse_native(text, filename)

    # ------------------------------------------------------------------
    # Official gherkin AST adapter
    # ------------------------------------------------------------------
    def _parse_official(self, text: str, filename: str) -> Feature:
        from gherkin.parser import Parser  # type: ignore
        from gherkin.token_scanner import TokenScanner  # type: ignore

        document = Parser().parse(TokenScanner(text))
        feature_ast = document.get("feature")
        if not feature_ast:
            return Feature(title="", filename=filename, raw_text=text, end_line=len(text.splitlines()), parser="gherkin-official")

        lines = text.splitlines()
        feature = Feature(
            title=feature_ast.get("name", "").strip(),
            language=feature_ast.get("language", "en"),
            description=feature_ast.get("description", "").strip(),
            tags=[tag.get("name", "") for tag in feature_ast.get("tags", [])],
            filename=filename,
            start_line=feature_ast.get("location", {}).get("line", 1),
            end_line=len(lines),
            raw_text=text,
            parser="gherkin-official",
        )

        def convert_step(step_ast: dict, inherited: bool = False) -> Step:
            location = step_ast.get("location", {})
            line = int(location.get("line", 0) or 0)
            argument = step_ast.get("docString") or step_ast.get("dataTable")
            doc_string = None
            table: List[List[str]] = []
            end_line = line
            if step_ast.get("docString"):
                doc_string = step_ast["docString"].get("content", "")
                end_line = step_ast["docString"].get("location", {}).get("line", line) + doc_string.count("\n") + 1
            elif step_ast.get("dataTable"):
                rows = step_ast["dataTable"].get("rows", [])
                table = [[cell.get("value", "") for cell in row.get("cells", [])] for row in rows]
                if rows:
                    end_line = rows[-1].get("location", {}).get("line", line)
            keyword = step_ast.get("keyword", "").strip()
            step_text = step_ast.get("text", "").strip()
            return Step(
                id=_step_id(filename, line, keyword, step_text),
                keyword=keyword,
                text=step_text,
                line_number=line,
                end_line=end_line,
                doc_string=doc_string,
                data_table=table,
                inherited=inherited,
            )

        def convert_examples(examples_ast: dict) -> ExampleSet:
            table_header = examples_ast.get("tableHeader") or {}
            headers = [cell.get("value", "") for cell in table_header.get("cells", [])]
            rows: List[Dict[str, str]] = []
            body = examples_ast.get("tableBody", [])
            for row in body:
                values = [cell.get("value", "") for cell in row.get("cells", [])]
                rows.append(dict(zip(headers, values)))
            start = examples_ast.get("location", {}).get("line", 0)
            end = body[-1].get("location", {}).get("line", start) if body else start
            return ExampleSet(
                name=examples_ast.get("name", ""),
                tags=[tag.get("name", "") for tag in examples_ast.get("tags", [])],
                headers=headers,
                rows=rows,
                start_line=start,
                end_line=end,
            )

        def convert_scenario(scenario_ast: dict, rule_name: Optional[str] = None) -> Scenario:
            start = scenario_ast.get("location", {}).get("line", 0)
            steps = [convert_step(step) for step in scenario_ast.get("steps", [])]
            examples = [convert_examples(ex) for ex in scenario_ast.get("examples", [])]
            candidate_lines = [step.end_line for step in steps] + [ex.end_line for ex in examples]
            end = max(candidate_lines or [start])
            block = "\n".join(lines[start - 1:end]) if start else ""
            return Scenario(
                title=scenario_ast.get("name", "").strip(),
                keyword=scenario_ast.get("keyword", "Scenario").strip().rstrip(":"),
                steps=steps,
                tags=[tag.get("name", "") for tag in scenario_ast.get("tags", [])],
                examples=examples,
                description=scenario_ast.get("description", "").strip(),
                rule=rule_name,
                start_line=start,
                end_line=end,
                block_text=block,
            )

        for child in feature_ast.get("children", []):
            if child.get("background"):
                bg_ast = child["background"]
                feature.background = convert_scenario(bg_ast)
                feature.background.keyword = "Background"
            elif child.get("scenario"):
                feature.scenarios.append(convert_scenario(child["scenario"]))
            elif child.get("rule"):
                rule_ast = child["rule"]
                rule_name = rule_ast.get("name", "").strip()
                rule = Rule(
                    title=rule_name,
                    tags=[tag.get("name", "") for tag in rule_ast.get("tags", [])],
                    description=rule_ast.get("description", "").strip(),
                    start_line=rule_ast.get("location", {}).get("line", 0),
                    end_line=rule_ast.get("location", {}).get("line", 0),
                )
                for rule_child in rule_ast.get("children", []):
                    if rule_child.get("background"):
                        rule.background = convert_scenario(rule_child["background"], rule_name)
                        rule.background.keyword = "Background"
                        rule.end_line = max(rule.end_line, rule.background.end_line)
                    elif rule_child.get("scenario"):
                        scenario = convert_scenario(rule_child["scenario"], rule_name)
                        inherited: List[Step] = []
                        if feature.background:
                            inherited.extend(
                                Step(**{**asdict(step), "inherited": True})
                                for step in feature.background.steps
                            )
                        if rule.background:
                            inherited.extend(
                                Step(**{**asdict(step), "inherited": True})
                                for step in rule.background.steps
                            )
                        scenario.steps = inherited + scenario.steps
                        feature.scenarios.append(scenario)
                        rule.end_line = max(rule.end_line, scenario.end_line)
                feature.rules.append(rule)

        if feature.background:
            for scenario in feature.scenarios:
                if scenario.rule:
                    continue
                inherited = [Step(**{**asdict(step), "inherited": True}) for step in feature.background.steps]
                scenario.steps = inherited + scenario.steps
        return feature

    # ------------------------------------------------------------------
    # Native parser
    # ------------------------------------------------------------------
    def _parse_native(self, text: str, filename: str) -> Feature:
        lines = text.splitlines()
        language_match = re.search(r"^\s*#\s*language\s*:\s*([\w-]+)", text, flags=re.MULTILINE | re.IGNORECASE)
        language = language_match.group(1).lower() if language_match else "en"
        keywords = _LANGUAGE_KEYWORDS.get(language, _LANGUAGE_KEYWORDS["en"])

        feature = Feature(
            title="",
            language=language,
            filename=filename,
            raw_text=text,
            end_line=len(lines),
            parser="native",
        )
        pending_tags: List[str] = []
        current_rule: Optional[Rule] = None
        current_scenario: Optional[Scenario] = None
        current_step: Optional[Step] = None
        current_examples: Optional[ExampleSet] = None
        current_table_rows: List[List[str]] = []
        in_doc_string = False
        doc_delimiter = ""
        doc_lines: List[str] = []
        doc_start_line = 0

        def close_examples() -> None:
            nonlocal current_examples, current_table_rows
            if current_examples is None:
                return
            if current_table_rows:
                current_examples.headers = current_table_rows[0]
                current_examples.rows = [
                    dict(zip(current_examples.headers, row))
                    for row in current_table_rows[1:]
                ]
                current_examples.end_line = current_examples.start_line + len(current_table_rows)
            current_examples = None
            current_table_rows = []

        def close_scenario(end_line: int) -> None:
            nonlocal current_scenario, current_step
            close_examples()
            if current_scenario is None:
                return
            current_scenario.end_line = max(current_scenario.start_line, end_line)
            if current_scenario.start_line:
                current_scenario.block_text = "\n".join(
                    lines[current_scenario.start_line - 1:current_scenario.end_line]
                ).rstrip()
            if current_scenario.keyword.lower() == "background":
                if current_scenario.rule and current_rule is not None:
                    current_rule.background = current_scenario
                else:
                    feature.background = current_scenario
            else:
                feature.scenarios.append(current_scenario)
            current_scenario = None
            current_step = None

        for index, raw_line in enumerate(lines, 1):
            stripped = raw_line.strip()

            if in_doc_string:
                if stripped.startswith(doc_delimiter):
                    if current_step is not None:
                        current_step.doc_string = "\n".join(doc_lines)
                        current_step.end_line = index
                    in_doc_string = False
                    doc_lines = []
                    doc_delimiter = ""
                else:
                    doc_lines.append(raw_line)
                continue

            if current_step is not None and stripped.startswith(('"""', "'''")):
                in_doc_string = True
                doc_delimiter = stripped[:3]
                doc_start_line = index
                doc_lines = []
                continue

            if stripped.startswith("#") or not stripped:
                continue

            if stripped.startswith("@"):
                pending_tags.extend(_split_tags(stripped))
                continue

            feature_match = _line_keyword(stripped, keywords["feature"])
            if feature_match:
                feature.title = feature_match[1]
                feature.tags = pending_tags
                feature.start_line = index
                pending_tags = []
                continue

            rule_match = _line_keyword(stripped, keywords["rule"])
            if rule_match:
                close_scenario(index - 1)
                if current_rule is not None:
                    current_rule.end_line = index - 1
                current_rule = Rule(
                    title=rule_match[1],
                    tags=pending_tags,
                    start_line=index,
                    end_line=index,
                )
                feature.rules.append(current_rule)
                pending_tags = []
                continue

            background_match = _line_keyword(stripped, keywords["background"])
            if background_match:
                close_scenario(index - 1)
                current_scenario = Scenario(
                    title=background_match[1] or "Background",
                    keyword="Background",
                    tags=pending_tags,
                    rule=current_rule.title if current_rule else None,
                    start_line=index,
                )
                pending_tags = []
                continue

            outline_match = _line_keyword(stripped, keywords["scenario_outline"])
            scenario_match = _line_keyword(stripped, keywords["scenario"])
            if outline_match or scenario_match:
                close_scenario(index - 1)
                matched = outline_match or scenario_match
                current_scenario = Scenario(
                    title=matched[1],
                    keyword="Scenario Outline" if outline_match else "Scenario",
                    tags=pending_tags,
                    rule=current_rule.title if current_rule else None,
                    start_line=index,
                )
                pending_tags = []
                continue

            examples_match = _line_keyword(stripped, keywords["examples"])
            if examples_match and current_scenario is not None:
                close_examples()
                current_examples = ExampleSet(
                    name=examples_match[1],
                    tags=pending_tags,
                    start_line=index,
                    end_line=index,
                )
                current_scenario.examples.append(current_examples)
                pending_tags = []
                current_table_rows = []
                continue

            if stripped.startswith("|") and stripped.endswith("|"):
                cells = _table_cells(stripped)
                if current_examples is not None:
                    current_table_rows.append(cells)
                    current_examples.end_line = index
                elif current_step is not None:
                    current_step.data_table.append(cells)
                    current_step.end_line = index
                continue

            step_match = _step_keyword(stripped, keywords)
            if step_match and current_scenario is not None:
                keyword, step_text = step_match
                current_step = Step(
                    id=_step_id(filename, index, keyword, step_text),
                    keyword=keyword,
                    text=step_text,
                    line_number=index,
                    end_line=index,
                )
                current_scenario.steps.append(current_step)
                continue

            # Free-form description lines belong to their nearest node.
            if current_scenario is not None and not current_scenario.steps:
                current_scenario.description = (current_scenario.description + "\n" + stripped).strip()
            elif current_rule is not None:
                current_rule.description = (current_rule.description + "\n" + stripped).strip()
            elif feature.title:
                feature.description = (feature.description + "\n" + stripped).strip()

        if in_doc_string and current_step is not None:
            current_step.doc_string = "\n".join(doc_lines)
            current_step.end_line = len(lines)
        close_scenario(len(lines))
        if current_rule is not None:
            current_rule.end_line = len(lines)

        rules_by_title = {rule.title: rule for rule in feature.rules}
        for scenario in feature.scenarios:
            inherited: List[Step] = []
            if feature.background:
                inherited.extend(
                    Step(**{**asdict(step), "inherited": True})
                    for step in feature.background.steps
                )
            rule = rules_by_title.get(scenario.rule or "")
            if rule and rule.background:
                inherited.extend(
                    Step(**{**asdict(step), "inherited": True})
                    for step in rule.background.steps
                )
            scenario.steps = inherited + scenario.steps
        return feature

    def extract_scenarios(self, text: str, filename: str = "<inline>") -> List[dict]:
        feature = self.parse(text, filename)

        # The supplied project stores reusable BDD content inside doc strings of
        # Behave test scenarios. Parse those inner documents structurally and
        # deduplicate requirement/test/UML wrappers for the same use case.
        embedded: Dict[str, dict] = {}
        for wrapper in feature.scenarios:
            for step in wrapper.steps:
                if not step.doc_string or not re.search(r"(?im)^\s*(Feature|Özellik|Ozellik)\s*:", step.doc_string):
                    continue
                nested_name = f"{filename}#L{step.line_number}"
                nested = self.parse(step.doc_string, nested_name)
                key_match = re.search(r"\bUC-[A-Z]+\d+\b", nested.title, flags=re.IGNORECASE)
                key = key_match.group(0).upper() if key_match else nested.title.casefold()
                if key not in embedded:
                    embedded[key] = {
                        "id": key if key else f"EMBEDDED-{len(embedded)+1}",
                        "title": nested.title or wrapper.title,
                        "blockText": step.doc_string.strip(),
                        "keyword": "Feature",
                        "stepCount": sum(len(s.steps) for s in nested.scenarios),
                        "tags": wrapper.tags,
                        "feature": nested.to_dict(),
                        "source": {
                            "file": filename,
                            "start_line": step.line_number,
                            "end_line": step.end_line,
                            "wrapper_scenario": wrapper.title,
                        },
                    }
        if embedded:
            return list(embedded.values())

        results: List[dict] = []
        for number, scenario in enumerate(feature.scenarios, 1):
            results.append({
                "id": f"SCN-{number:03d}",
                "title": scenario.title,
                "blockText": scenario.block_text,
                "keyword": scenario.keyword,
                "stepCount": len(scenario.steps),
                "tags": scenario.tags,
                "rule": scenario.rule,
                "examples": [asdict(example) for example in scenario.examples],
                "steps": [asdict(step) for step in scenario.steps],
                "source": {
                    "file": filename,
                    "start_line": scenario.start_line,
                    "end_line": scenario.end_line,
                },
            })
        if not results and text.strip():
            results.append({
                "id": "FEATURE-001",
                "title": feature.title or "Full Feature",
                "blockText": text.strip(),
                "keyword": "Feature",
                "stepCount": 0,
                "tags": feature.tags,
                "source": {"file": filename, "start_line": 1, "end_line": len(text.splitlines())},
            })
        return results

    def build_source_context(self, text: str, filename: str = "<inline>") -> dict:
        feature = self.parse(text, filename)
        scenarios = []
        for scenario in feature.scenarios:
            scenarios.append({
                "name": scenario.title,
                "keyword": scenario.keyword,
                "rule": scenario.rule,
                "tags": scenario.tags,
                "start_line": scenario.start_line,
                "end_line": scenario.end_line,
                "examples": [asdict(example) for example in scenario.examples],
                "steps": [
                    {
                        "id": step.id,
                        "keyword": step.keyword.strip(),
                        "text": step.text,
                        "display_text": step.display_text(),
                        "start_line": step.line_number,
                        "end_line": step.end_line,
                        "inherited": step.inherited,
                        "doc_string": step.doc_string,
                        "data_table": step.data_table,
                    }
                    for step in scenario.steps
                ],
            })
        return {
            "source_file": filename,
            "feature": feature.title,
            "language": feature.language,
            "description": feature.description,
            "tags": feature.tags,
            "scenarios": scenarios,
            "parser": feature.parser,
        }


_parser = GherkinParser()


def parse_feature(text: str, filename: str = "<inline>") -> Feature:
    return _parser.parse(text, filename)


def parse_feature_file(text: str, filename: str = "<inline>") -> dict:
    return _parser.parse(text, filename).to_dict()


def extract_scenarios(text: str, filename: str = "<inline>") -> List[dict]:
    return _parser.extract_scenarios(text, filename)


def build_source_context(text: str, filename: str = "<inline>") -> dict:
    return _parser.build_source_context(text, filename)
