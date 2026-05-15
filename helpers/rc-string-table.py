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


@dataclass(frozen=True)
class RcStrings:
    """Parsed string resources plus duplicate ids found while parsing."""

    values: dict[str, str]
    duplicates: list[str]


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


def parse_id_list(path: Path | None) -> list[str]:
    """Parse required resource ids from a one-id-per-line file."""

    if path is None:
        return []
    ids: list[str] = []
    seen: Counter[str] = Counter()
    for line_no, raw_line in enumerate(path.read_text(encoding="utf-8-sig").splitlines(), 1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if not re.fullmatch(r"IDS_[A-Z0-9_]+", line):
            raise SystemExit(f"ID list line {line_no} has invalid resource id: {line}")
        seen[line] += 1
        ids.append(line)
    duplicates = sorted(key for key, count in seen.items() if count > 1)
    if duplicates:
        raise SystemExit("Duplicate required resource ids: " + ", ".join(duplicates))
    return ids


def require_ids(rows: list[tuple[str, str]], required_ids: list[str], label: str) -> None:
    """Fail when a translation row set misses a required resource id."""

    if not required_ids:
        return
    available = {key for key, _ in rows}
    missing = [key for key in required_ids if key not in available]
    if missing:
        raise SystemExit(f"{label} is missing required resource ids:\n" + "\n".join(missing))


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
    """Collect RC string literals by resource id."""

    return collect_rc_strings(path).values


def _decode_rc_literal(raw_value: str) -> str:
    """Decode one RC string literal payload."""

    return raw_value.replace('""', '"')


def _string_literal_from_line(line: str) -> str | None:
    """Return the first RC string literal payload from a line, if present."""

    match = re.search(r'"((?:[^"]|"")*)"', line)
    if not match:
        return None
    return _decode_rc_literal(match.group(1))


def collect_rc_strings(path: Path) -> RcStrings:
    """Collect one-line and next-line RC string literals by resource id."""

    text = read_rc(path).text
    found: dict[str, str] = {}
    seen: Counter[str] = Counter()
    lines = text.splitlines()
    index = 0
    while index < len(lines):
        line = lines[index]
        match = re.match(r"\s*(IDS_[A-Z0-9_]+)\b(.*)$", line)
        if not match:
            index += 1
            continue
        key = match.group(1)
        value = _string_literal_from_line(match.group(2))
        if value is None and index + 1 < len(lines):
            value = _string_literal_from_line(lines[index + 1])
            if value is not None:
                index += 1
        if value is not None:
            seen[key] += 1
            found[key] = value
        index += 1
    duplicates = sorted(key for key, count in seen.items() if count > 1)
    return RcStrings(values=found, duplicates=duplicates)


def _required_or_source_ids(required_ids: list[str], source: dict[str, str]) -> list[str]:
    """Return explicit required ids or all source ids in source order."""

    return required_ids if required_ids else list(source)


def cross_reference(args: argparse.Namespace) -> None:
    """Cross-reference source and target RC string resources."""

    if not args.english_rc:
        raise SystemExit("--cross-reference requires --english-rc.")
    targets = list(args.target_rc or [])
    if args.rc:
        targets.append(args.rc)
    if not targets:
        raise SystemExit("--cross-reference requires at least one --target-rc or --rc.")

    source = collect_rc_strings(args.english_rc)
    required_ids = _required_or_source_ids(parse_id_list(args.require_ids), source.values)
    missing_in_source = [key for key in required_ids if key not in source.values]
    if source.duplicates:
        raise SystemExit(
            f"{args.english_rc} has duplicate resource ids:\n" + "\n".join(source.duplicates)
        )
    if missing_in_source:
        raise SystemExit(
            f"{args.english_rc} is missing required resource ids:\n" + "\n".join(missing_in_source)
        )

    errors: list[str] = []
    for target_path in targets:
        target = collect_rc_strings(target_path)
        target_ids = set(target.values)
        missing = [key for key in required_ids if key not in target_ids]
        extra = sorted(key for key in target_ids if key not in source.values)
        placeholder_errors = []
        for key in required_ids:
            if key not in target.values:
                continue
            expected = placeholders(source.values[key])
            actual = placeholders(target.values[key])
            if expected != actual:
                placeholder_errors.append(f"{key}: expected {expected}, got {actual}")
        if target.duplicates:
            errors.append(f"{target_path}: duplicate ids:\n" + "\n".join(target.duplicates))
        if missing:
            errors.append(f"{target_path}: missing ids:\n" + "\n".join(missing))
        if placeholder_errors:
            errors.append(f"{target_path}: placeholder mismatch:\n" + "\n".join(placeholder_errors))
        extra_text = f", {len(extra)} ids not present in source" if extra else ""
        print(f"OK {target_path}: {len(required_ids) - len(missing)}/{len(required_ids)} required ids{extra_text}")
    if errors:
        raise SystemExit("\n\n".join(errors))


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

    if not args.rc:
        raise SystemExit("--rc is required unless --cross-reference uses --target-rc.")
    rows = parse_tsv(args.tsv)
    required_ids = parse_id_list(args.require_ids)
    require_ids(rows, required_ids, "TSV")
    if args.english_rc:
        validate_placeholders(args.english_rc, rows)
    rc_text = read_rc(args.rc)
    endif = find_resource_endif(rc_text.text)
    before = rc_text.text[: endif.start()]
    after = rc_text.text[endif.start() :]
    before = strip_managed_or_probe_block(before, args.probe_start, args.probe_end)
    write_rc(args.rc, rc_text, before + build_string_table(rows) + after)


def audit_block(args: argparse.Namespace) -> None:
    """Audit one RC file for required ids and optional placeholder parity."""

    if not args.rc:
        raise SystemExit("--rc is required for --audit.")
    rows = list(collect_strings(args.rc).items())
    required_ids = parse_id_list(args.require_ids)
    require_ids(rows, required_ids, str(args.rc))
    if args.english_rc:
        validate_placeholders(args.english_rc, rows)
    print(f"OK {args.rc}")


def main() -> int:
    """Command-line entry point."""

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rc", type=Path, help="RC file to edit or audit.")
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
    parser.add_argument(
        "--target-rc",
        type=Path,
        action="append",
        help="Target RC file for --cross-reference. Can be passed more than once.",
    )
    parser.add_argument(
        "--require-ids",
        type=Path,
        help="Optional one-id-per-line file of resource ids that must be present.",
    )
    parser.add_argument(
        "--audit",
        action="store_true",
        help="Only audit the RC file for required ids/placeholders; do not edit.",
    )
    parser.add_argument(
        "--cross-reference",
        action="store_true",
        help="Compare English/source resource ids against target RC files.",
    )
    parser.add_argument("--probe-start", default=DEFAULT_PROBE_START)
    parser.add_argument("--probe-end", default=DEFAULT_PROBE_END)
    args = parser.parse_args()
    if args.cross_reference:
        cross_reference(args)
    elif args.audit:
        audit_block(args)
    else:
        apply_block(args)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
