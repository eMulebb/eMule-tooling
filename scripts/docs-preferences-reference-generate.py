from __future__ import annotations

import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any


BEGIN_MARKER = "<!-- BEGIN GENERATED PREFERENCES.INI REFERENCE -->"
END_MARKER = "<!-- END GENERATED PREFERENCES.INI REFERENCE -->"


def _workspace_root() -> Path:
    return Path(__file__).resolve().parents[3]


def _display(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, list):
        return ", ".join(str(item) for item in value if str(item))
    return str(value)


def _markdown_cell(value: Any, empty: str = "None") -> str:
    text = _display(value).strip()
    if not text:
        text = empty
    text = text.replace("\\", "\\\\")
    text = text.replace("|", "\\|")
    text = text.replace("\r\n", " ").replace("\n", " ")
    return text


def _binding_summary(bindings: list[str]) -> str:
    if not bindings:
        return "None"
    files = []
    for binding in bindings:
        if ":" in binding:
            files.append(binding.split(":", 1)[0])
        else:
            files.append(binding)
    unique_files = sorted(set(files))
    if len(unique_files) == 1:
        return unique_files[0]
    if len(unique_files) <= 3:
        return ", ".join(unique_files)
    return ", ".join(unique_files[:3]) + f", +{len(unique_files) - 3} more"


def _normalizer_summary(entry: dict[str, Any]) -> str:
    pieces = []
    default_expression = _display(entry.get("defaultExpression")).strip()
    clamp_or_normalizer = _display(entry.get("clampOrNormalizer")).strip()
    if default_expression:
        pieces.append(f"default: {default_expression}")
    if clamp_or_normalizer:
        pieces.append(f"normalizer: {clamp_or_normalizer}")
    return "; ".join(pieces) if pieces else "Not explicitly declared in schema"


def _entry_sort_key(entry: dict[str, Any]) -> tuple[str, str, str]:
    return (
        str(entry.get("section") or "<default>").lower(),
        str(entry.get("classification") or "").lower(),
        str(entry.get("key") or entry.get("id") or "").lower(),
    )


def build_reference(schema_path: Path, workspace_root: Path) -> str:
    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    entries = [
        entry
        for entry in schema["entries"]
        if entry.get("storageFile") == "preferences.ini"
    ]
    entries.sort(key=_entry_sort_key)

    section_groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for entry in entries:
        section_groups[str(entry.get("section") or "<default>")].append(entry)

    schema_display_path = schema_path.relative_to(workspace_root).as_posix()
    lines: list[str] = [
        BEGIN_MARKER,
        "",
        f"Generated from `{schema_display_path}`.",
        "",
        f"Total `preferences.ini` schema entries: **{len(entries)}**.",
        "",
        "Dynamic rows are generated families tracked by source expression rather",
        "than a finite static key list. Empty defaults or normalizers mean the",
        "schema did not declare a single explicit value; check the behavior prose",
        "and the preference surface matrix for user-facing defaults and ranges.",
        "",
    ]

    for section in sorted(section_groups, key=lambda item: (item != "<default>", item.lower())):
        section_entries = section_groups[section]
        lines.extend(
            [
                f"### `{section}`",
                "",
            ]
        )
        by_classification: dict[str, list[dict[str, Any]]] = defaultdict(list)
        for entry in section_entries:
            by_classification[str(entry.get("classification") or "unclassified")].append(entry)

        for classification in sorted(by_classification):
            class_entries = sorted(
                by_classification[classification],
                key=lambda item: str(item.get("key") or item.get("id") or "").lower(),
            )
            lines.extend(
                [
                    f"#### {classification}",
                    "",
                    "| Key | Type | Access | Owner/API | Default and normalization | UI | REST | Notes |",
                    "|---|---|---|---|---|---|---|---|",
                ]
            )
            for entry in class_entries:
                key = entry.get("key") or entry.get("id")
                owner = entry.get("ownerExpressions") or []
                ui = _binding_summary(entry.get("uiBindingIds") or [])
                rest = _display(entry.get("restBindings") or [])
                lines.append(
                    "| "
                    + " | ".join(
                        [
                            f"`{_markdown_cell(key)}`",
                            _markdown_cell(entry.get("valueType")),
                            _markdown_cell(entry.get("access")),
                            _markdown_cell(owner),
                            _markdown_cell(_normalizer_summary(entry)),
                            _markdown_cell(ui),
                            _markdown_cell(rest),
                            _markdown_cell(entry.get("notes")),
                        ]
                    )
                    + " |"
                )
            lines.append("")

    lines.append(END_MARKER)
    return "\n".join(lines) + "\n"


def update_guide(guide_path: Path, generated: str, check: bool) -> bool:
    original = guide_path.read_text(encoding="utf-8")
    begin = original.find(BEGIN_MARKER)
    end = original.find(END_MARKER)
    if begin < 0 or end < 0 or end < begin:
        raise SystemExit(f"Missing generated block markers in {guide_path}")
    end += len(END_MARKER)
    updated = original[:begin] + generated.rstrip("\n") + original[end:]
    if updated == original:
        return False
    if check:
        raise SystemExit(f"{guide_path} is stale; run this script without --check")
    guide_path.write_text(updated, encoding="utf-8", newline="\n")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate the complete preferences.ini reference inside GUIDE-PREFERENCES.md."
    )
    parser.add_argument(
        "--workspace-root",
        type=Path,
        default=_workspace_root(),
        help="Workspace root containing repos and workspaces.",
    )
    parser.add_argument("--check", action="store_true", help="Fail if GUIDE-PREFERENCES.md is stale.")
    args = parser.parse_args()

    workspace_root = args.workspace_root.resolve()
    schema_path = workspace_root / "repos" / "eMule-build-tests" / "manifests" / "preference-schema.v1.json"
    guide_path = workspace_root / "repos" / "eMule-tooling" / "docs" / "reference" / "GUIDE-PREFERENCES.md"
    generated = build_reference(schema_path, workspace_root)
    changed = update_guide(guide_path, generated, args.check)
    if args.check:
        print(f"{guide_path} is current")
    elif changed:
        print(f"Updated {guide_path}")
    else:
        print(f"{guide_path} already current")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
