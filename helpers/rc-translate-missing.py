#!/usr/bin/env python3
"""Translate missing Windows RC string resources into a managed string table."""

from __future__ import annotations

import argparse
import importlib.util
import json
import re
import sys
import time
from pathlib import Path


TOOL_DIR = Path(__file__).resolve().parent
STRING_TABLE_HELPER = TOOL_DIR / "rc-string-table.py"
DEFAULT_CACHE = TOOL_DIR.parent / ".local" / "rc-translation-cache.json"
DEFAULT_PROTECT_TERMS = [
    "eMule BB",
    "eMule",
    "eMule Plus",
    "eMuleFuture",
    "eDonkey",
    "eD2K",
    "Kad",
    "Kademlia",
    "ED2K",
    "TCP",
    "UDP",
    "UPnP",
    "NAT-PMP",
    "PCP",
    "HTTP",
    "HTTPS",
    "REST",
    "REST API",
    "JSON",
    "CSV",
    "MRTG",
    "IRC",
    "IP",
    "IPv4",
    "IPv6",
    "LowID",
    "HighID",
    "WebServer",
    "Web UI",
    "Windows",
    "Windows Firewall",
    "FFmpeg",
    "VLC",
    "MediaInfo",
    "MediaInfo.dll",
    "ffmpeg.exe",
]
FILENAME_RE = re.compile(
    r"\b[\w.-]+\.(?:ini|dat|met|dll|exe|log|txt|xml|tmpl|css|js|html|zip|rar|7z|part|bak)\b",
    re.IGNORECASE,
)
URL_RE = re.compile(r"\b(?:https?|ed2k)://[^\s\"<>]+", re.IGNORECASE)
PLACEHOLDER_RE = re.compile(r"%(?:%|[-+ #0]*\d*(?:\.\d+)?[hlI64]*[A-Za-z])")
ESCAPE_RE = re.compile(r"\\(?:r\\n|n|r|t)")
TOKEN_RE = re.compile(r"QZX(\d+)XZQ")


def load_rc_helper():
    """Load the RC string-table helper module from the same directory."""

    spec = importlib.util.spec_from_file_location("rc_string_table", STRING_TABLE_HELPER)
    if spec is None or spec.loader is None:
        raise SystemExit(f"Cannot load helper: {STRING_TABLE_HELPER}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def load_translator(target: str):
    """Create a GoogleTranslator instance with an actionable dependency error."""

    try:
        from deep_translator import GoogleTranslator
    except ImportError as exc:
        raise SystemExit(
            "Missing dependency. Install with: python -m pip install --user deep-translator"
        ) from exc
    return GoogleTranslator(source="en", target=target)


def load_cache(path: Path) -> dict[str, dict[str, str]]:
    """Load the translation cache."""

    if not path.is_file():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def save_cache(path: Path, cache: dict[str, dict[str, str]]) -> None:
    """Persist the translation cache atomically enough for one local process."""

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(cache, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def add_token(tokens: list[str], value: str) -> str:
    """Add a protected value and return its token."""

    token = f"QZX{len(tokens)}XZQ"
    tokens.append(value)
    return token


def protect_text(text: str, extra_terms: list[str]) -> tuple[str, list[str]]:
    """Protect placeholders and literals that translators must not alter."""

    tokens: list[str] = []
    protected = text
    for regex in (URL_RE, FILENAME_RE, PLACEHOLDER_RE, ESCAPE_RE):
        protected = regex.sub(lambda match: add_token(tokens, match.group(0)), protected)
    for term in sorted(DEFAULT_PROTECT_TERMS + extra_terms, key=len, reverse=True):
        protected = re.sub(re.escape(term), lambda match: add_token(tokens, match.group(0)), protected)
    return protected, tokens


def restore_text(text: str, tokens: list[str]) -> str:
    """Restore protected tokens after translation."""

    restored = text
    for match in sorted(TOKEN_RE.findall(restored), key=lambda value: int(value), reverse=True):
        index = int(match)
        if 0 <= index < len(tokens):
            restored = restored.replace(f"QZX{match}XZQ", tokens[index])
    for old, new in (
        (" \\r\\n ", "\\r\\n"),
        ("\\r\\n ", "\\r\\n"),
        (" \\r\\n", "\\r\\n"),
        (" \\n ", "\\n"),
        ("\\n ", "\\n"),
        (" \\n", "\\n"),
        (" \\t ", "\\t"),
        ("\\t ", "\\t"),
        (" \\t", "\\t"),
    ):
        restored = restored.replace(old, new)
    return restored


def normalize_mnemonic(source: str, translated: str) -> str:
    """Keep one menu mnemonic when the English source had one."""

    if "&" not in source:
        return translated.replace("&", "")
    translated = translated.replace("&", "")
    match = re.search(r"\w", translated, re.UNICODE)
    if not match:
        return translated
    return translated[: match.start()] + "&" + translated[match.start() :]


def translate_value(translator, source: str, extra_terms: list[str]) -> str:
    """Translate one RC string value while preserving RC-sensitive tokens."""

    protected, tokens = protect_text(source.replace("&", ""), extra_terms)
    for attempt in range(5):
        try:
            translated = translator.translate(protected)
            if translated is None:
                raise RuntimeError("translator returned no text")
            return normalize_mnemonic(source, restore_text(translated, tokens))
        except Exception:
            if attempt == 4:
                raise
            time.sleep(1.5 * (attempt + 1))
    raise AssertionError("unreachable")


def managed_rows(rc_helper, path: Path) -> list[tuple[str, str]]:
    """Return rows from the existing managed block, if any."""

    text = rc_helper.read_rc(path).text
    block = re.search(
        r"// eMule BB managed translation block: begin.*?// eMule BB managed translation block: end",
        text,
        re.S,
    )
    if not block:
        return []
    return [
        (key, raw.replace('""', '"'))
        for key, raw in re.findall(r'^\s*(IDS_[A-Z0-9_]+)\s+"((?:[^"]|"")*)"', block.group(0), re.M)
    ]


def collect_missing_ids(source: dict[str, str], target: dict[str, str], required: list[str]) -> list[str]:
    """Return missing ids in source order, optionally constrained by required ids."""

    wanted = required if required else list(source)
    return [key for key in wanted if key in source and key not in target]


def apply_rows(rc_helper, path: Path, rows: list[tuple[str, str]]) -> None:
    """Rewrite the managed block with the provided rows."""

    rc_text = rc_helper.read_rc(path)
    endif = rc_helper.find_resource_endif(rc_text.text)
    before = rc_helper.strip_managed_or_probe_block(
        rc_text.text[: endif.start()],
        rc_helper.DEFAULT_PROBE_START,
        rc_helper.DEFAULT_PROBE_END,
    )
    rc_helper.write_rc(path, rc_text, before + rc_helper.build_string_table(rows) + rc_text.text[endif.start() :])


def run(args: argparse.Namespace) -> None:
    """Translate missing strings and update the target RC managed block."""

    rc_helper = load_rc_helper()
    translator = load_translator(args.target_lang)
    source = rc_helper.collect_rc_strings(args.source_rc)
    target = rc_helper.collect_rc_strings(args.target_rc)
    required = rc_helper.parse_id_list(args.require_ids)
    existing_rows = managed_rows(rc_helper, args.target_rc)
    existing_map = dict(existing_rows)
    missing = collect_missing_ids(source.values, target.values, required)
    cache = load_cache(args.cache)
    cache_key = f"{args.target_lang}:{args.target_rc.name}"
    cache.setdefault(cache_key, {})

    new_rows: list[tuple[str, str]] = []
    for index, key in enumerate(missing, 1):
        if key in existing_map:
            continue
        if key not in cache[cache_key]:
            value = translate_value(translator, source.values[key], args.protect_term)
            cache[cache_key][key] = value
            save_cache(args.cache, cache)
        new_rows.append((key, cache[cache_key][key]))
        if args.progress and (index == 1 or index % args.progress == 0 or index == len(missing)):
            print(f"{args.target_rc.name}: translated {index}/{len(missing)} missing ids")

    rows = existing_rows + new_rows
    if not args.dry_run:
        rc_helper.validate_placeholders(args.source_rc, rows)
        apply_rows(rc_helper, args.target_rc, rows)
    print(f"{args.target_rc}: added {len(new_rows)} rows, managed rows {len(rows)}")


def main() -> int:
    """Command-line entry point."""

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-rc", type=Path, required=True, help="English/source RC file.")
    parser.add_argument("--target-rc", type=Path, required=True, help="Target language RC file.")
    parser.add_argument("--target-lang", required=True, help="deep-translator target language code.")
    parser.add_argument("--require-ids", type=Path, help="Optional one-id-per-line resource id list.")
    parser.add_argument("--cache", type=Path, default=DEFAULT_CACHE, help="Translation cache path.")
    parser.add_argument("--protect-term", action="append", default=[], help="Additional literal term to preserve.")
    parser.add_argument("--progress", type=int, default=25, help="Progress interval; 0 disables progress.")
    parser.add_argument("--dry-run", action="store_true", help="Translate/cache but do not rewrite the target RC.")
    args = parser.parse_args()
    run(args)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
