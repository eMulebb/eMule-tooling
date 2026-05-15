#!/usr/bin/env python3
"""Insert managed Windows RC string-table entries from TSV input."""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from dataclasses import dataclass
from pathlib import Path


UTF8_BOM = b"\xef\xbb\xbf"
START_MARKER = "// eMule BB managed translation block: begin"
END_MARKER = "// eMule BB managed translation block: end"
DEFAULT_PROBE_START = "IDS_ENABLE_IPFILTER"
DEFAULT_PROBE_END = "IDS_ALWAYS_SHOW_TRAY_ICON"


@dataclass(frozen=True)
class RcText:
    """Decoded RC text plus enough metadata to preserve file style."""

    text: str
    newline: str
    has_utf8_bom: bool


def read_rc(path: Path) -> RcText:
    """Read an RC file while preserving its UTF-8 BOM and dominant newline."""

    data = path.read_bytes()
    has_bom = data.startswith(UTF8_BOM)
    text = data.decode("utf-8-sig")
    crlf = text.count("\r\n")
    lf = text.count("\n") - crlf
    newline = "\r\n" if crlf >= lf else "\n"
    return RcText(text=text, newline=newline, has_utf8_bom=has_bom)


def write_rc(path: Path, rc_text: RcText, text: str) -> None:
    """Write RC text with the same UTF-8 BOM and newline convention."""

    normalized = text.replace("\r\n", "\n").replace("\r", "\n")
    if rc_text.newline != "\n":
        normalized = normalized.replace("\n", rc_text.newline)
    data = normalized.encode("utf-8")
    if rc_text.has_utf8_bom:
        data = UTF8_BOM + data
    path.write_bytes(data)


def parse_tsv(path: Path | None) -> list[tuple[str, str]]:
    """Parse KEY<TAB>VALUE lines from a TSV file or stdin."""

    source = sys.stdin.read() if path is None else path.read_text(encoding="utf-8-sig")
    rows: list[tuple[str, str]] = []
    seen: Counter[str] = Counter()
    for line_no, raw_line in enumerate(source.splitlines(), 1):
        line = raw_line.rstrip("\n")
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        parts = line.split("\t", 1)
        if len(parts) != 2:
            raise SystemExit(f"TSV line {line_no} must be KEY<TAB>VALUE")
        key, value = parts[0].strip(), parts[1]
        if not re.fullmatch(r"IDS_[A-Z0-9_]+", key):
            raise SystemExit(f"TSV line {line_no} has invalid resource id: {key}")
        seen[key] += 1
        rows.append((key, value))
    duplicates = sorted(key for key, count in seen.items() if count > 1)
    if duplicates:
        raise SystemExit("Duplicate TSV resource ids: " + ", ".join(duplicates))
    return rows


def escape_rc_string(value: str) -> str:
    """Escape a Python string value for a single-line RC string literal."""

    if "\r" in value or "\n" in value:
        raise SystemExit("Multiline RC values are intentionally not accepted by this helper.")
    return value.replace('"', '""')


def find_resource_endif(text: str) -> re.Match[str]:
    """Find the language resource #endif that closes the active RC block."""

    match = re.search(r"\r?\n#endif\s+// .* resources", text)
    if not match:
        raise SystemExit("Could not find the language resource #endif marker.")
    return match


def strip_managed_or_probe_block(text: str, probe_start: str, probe_end: str) -> str:
    """Remove a previous managed block or one matching the probe ids."""

    line = r"\r?\n"
    managed = re.compile(
        rf"{line}{re.escape(START_MARKER)}{line}.*?{line}{re.escape(END_MARKER)}{line}",
        re.DOTALL,
    )
    text = managed.sub("\n", text)

    string_table = re.compile(r"\r?\nSTRINGTABLE\r?\nBEGIN\r?\n.*?\r?\nEND\r?\n", re.DOTALL)
    text = string_table.sub(
        lambda match: "\n" if probe_start in match.group(0) and probe_end in match.group(0) else match.group(0),
        text,
    )
    return text.rstrip() + "\n\n"


def build_string_table(rows: list[tuple[str, str]]) -> str:
    """Build a marked RC STRINGTABLE block."""

    if not rows:
        raise SystemExit("No rows to insert.")
    width = max(len(key) for key, _ in rows)
    lines = [
        START_MARKER,
        "STRINGTABLE",
        "BEGIN",
    ]
    lines.extend(f'    {key:<{width}} "{escape_rc_string(value)}"' for key, value in rows)
    lines.extend(["END", END_MARKER, ""])
    return "\n".join(lines)


PLACEHOLDER_RE = re.compile(r"%(?:%|[-+ #0]*\d*(?:\.\d+)?[hlI64]*[A-Za-z])")


def placeholders(value: str) -> list[str]:
    """Return printf-style placeholders, ignoring literal percent escapes."""

    return [item for item in PLACEHOLDER_RE.findall(value) if item != "%%"]


def collect_strings(path: Path) -> dict[str, str]:
    """Collect simple one-line RC string literals by resource id."""

    text = read_rc(path).text
    found: dict[str, str] = {}
    simple = re.compile(r'^\s*(IDS_[A-Z0-9_]+)\s+"((?:[^"]|"")*)"', re.MULTILINE)
    for key, raw_value in simple.findall(text):
        found[key] = raw_value.replace('""', '"')
    return found


def validate_placeholders(english_rc: Path, rows: list[tuple[str, str]]) -> None:
    """Fail when translated printf placeholders differ from English."""

    english = collect_strings(english_rc)
    errors: list[str] = []
    for key, value in rows:
        if key not in english:
            continue
        expected = placeholders(english[key])
        actual = placeholders(value)
        if expected != actual:
            errors.append(f"{key}: expected {expected}, got {actual}")
    if errors:
        raise SystemExit("Placeholder mismatch:\n" + "\n".join(errors))


def apply_block(args: argparse.Namespace) -> None:
    """Apply a TSV-backed managed block to one RC file."""

    rows = parse_tsv(args.tsv)
    if args.english_rc:
        validate_placeholders(args.english_rc, rows)
    rc_text = read_rc(args.rc)
    endif = find_resource_endif(rc_text.text)
    before = rc_text.text[: endif.start()]
    after = rc_text.text[endif.start() :]
    before = strip_managed_or_probe_block(before, args.probe_start, args.probe_end)
    write_rc(args.rc, rc_text, before + build_string_table(rows) + after)


def main() -> int:
    """Command-line entry point."""

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rc", type=Path, required=True, help="RC file to edit.")
    parser.add_argument(
        "--tsv",
        type=Path,
        help="KEY<TAB>VALUE translation input. Reads stdin when omitted.",
    )
    parser.add_argument(
        "--english-rc",
        type=Path,
        help="Optional English RC file used for printf placeholder validation.",
    )
    parser.add_argument("--probe-start", default=DEFAULT_PROBE_START)
    parser.add_argument("--probe-end", default=DEFAULT_PROBE_END)
    args = parser.parse_args()
    apply_block(args)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
