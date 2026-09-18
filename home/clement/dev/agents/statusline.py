"""Claude Code status line.

Reads the session JSON on stdin and writes two ANSI lines: model, rate
limit windows and context usage, then host, session name and the jj
working copy.

Colour lives in rich console markup, so every value taken from the JSON
goes through `escape` before it reaches a section.
"""

import json
import math
import os
import re
import subprocess
import sys
import time
import zlib
from pathlib import Path
from typing import Any, Final

from rich.console import Console
from rich.markup import escape

MISSING: Final = "--"
BRAND: Final = "#d97757"
SEPARATOR: Final = "  [dim]-[/]  "

HOST_COLORS: Final = {
    "lucy": "#33985d",
    "maine": "#d54c55",
    "rebecca": "#5595ce",
    "kiwi": "#b08c29",
}

# Twelve hues at one luminance, so a hashed host stays as readable as a
# named one. Half of the 256-colour cube is illegible on one background
# or the other, hence the hand-picked list.
HOST_PALETTE: Final = (
    "#d05d5d", "#b27334", "#858527", "#5c8f29",
    "#2b942b", "#2a925e", "#298f8f", "#4185c8",
    "#7777d8", "#9e68d3", "#cb4bcb", "#ce5792",
)

JJ_TEMPLATE: Final = (
    r'change_id.shortest(8).prefix() ++ "\t" ++ change_id.shortest(8).rest()'
    r' ++ "\t" ++ diff.stat()'
)
JJ_STAT_SUMMARY: Final = re.compile(
    r"(\d+) insertions?\(\+\), (\d+) deletions?\(-\)$"
)


def percent(value: Any) -> int | None:
    """Floor a used_percentage, or None when the field is absent."""
    if isinstance(value, (int, float)):
        return math.floor(value)
    return None


def compact(value: Any) -> str:
    """Token count in short form: 1234567 -> 1.2M."""
    if not isinstance(value, (int, float)):
        return MISSING
    for unit, scale in (("M", 10**6), ("k", 10**3)):
        if value >= scale:
            return f"{math.floor(value / scale * 10) / 10:g}{unit}"
    return str(math.floor(value))


def remaining(resets_at: Any) -> str:
    """Time left until a unix timestamp, coarsest two units only."""
    if not isinstance(resets_at, (int, float)):
        return MISSING
    left = math.floor(resets_at - time.time())
    if left <= 0:
        return "now"
    days, rest = divmod(left, 86400)
    hours, minutes = divmod(rest // 60, 60)
    if days:
        return f"{days}d{hours}h"
    if hours:
        return f"{hours}h{minutes}m"
    return f"{minutes}m"


def gauge(resets_at: Any, used: int) -> str:
    level = "red" if used >= 80 else "yellow" if used >= 50 else "dim"
    return f"[dim]{remaining(resets_at)}[/] [{level}]{used}%[/]"


def overage(data: dict[str, Any], used: list[int | None]) -> str | None:
    """Spend to show next to the gauges, or None when there is nothing.

    Neither the extra usage flag nor the credit spend reaches the status
    line, so a window reading 100 stands in for "past the plan", and no
    window at all for a model outside it. The figure is the client-side
    list price estimate, not the amount actually billed.
    """
    cost = (data.get("cost") or {}).get("total_cost_usd") or 0.0
    session_id = data.get("session_id") or ""
    if all(value is None for value in used):
        spent = cost
    elif session_id and 100 in used:
        runtime = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp"))
        baseline = runtime / f"claude-cost-{session_id}"
        if not baseline.exists():
            baseline.write_text(str(cost))
        spent = cost - float(baseline.read_text())
    else:
        return None
    return f"[yellow]+${spent:.2f}[/]" if round(spent, 2) > 0 else None


def host_style(host: str) -> str:
    named = HOST_COLORS.get(host)
    if named is not None:
        return named
    return HOST_PALETTE[zlib.crc32(host.encode()) % len(HOST_PALETTE)]


def working_copy() -> str | None:
    """Change id and diff stat, or None outside a jj repo.

    --ignore-working-copy skips the snapshot, which the PostToolUse hook
    already takes. Without it the status line blocks on the working copy
    lock on every refresh.

    The template renders the whole diff.stat() and parses its summary line:
    each total_added() or total_removed() call computes the diff again.
    """
    try:
        out = subprocess.run(
            ["jj", "log", "-r", "@", "--no-graph", "--color=never",
             "--ignore-working-copy", "-T", JJ_TEMPLATE],
            capture_output=True, text=True, check=True,
        ).stdout
    except (OSError, subprocess.CalledProcessError):
        return None
    prefix, rest, stat = out.split("\t", 2)
    section = f"[bold]{prefix}[/][dim]{rest}[/]"
    summary = JJ_STAT_SUMMARY.search(stat)
    if summary and summary.groups() != ("0", "0"):
        added, removed = summary.groups()
        section += f" [green]+{added}[/] [red]-{removed}[/]"
    return section


def main() -> None:
    data = json.load(sys.stdin)
    limits = data.get("rate_limits") or {}
    windows = [limits.get("five_hour") or {}, limits.get("seven_day") or {}]
    used = [percent(w.get("used_percentage")) for w in windows]

    usage = [
        gauge(w.get("resets_at"), u)
        for w, u in zip(windows, used)
        if u is not None
    ]
    spent = overage(data, used)
    if spent is not None:
        usage.append(spent)

    context = data.get("context_window") or {}
    ctx = percent(context.get("used_percentage"))
    ctx_text = f"{ctx}%" if ctx is not None else MISSING
    model = escape((data.get("model") or {}).get("display_name") or MISSING)

    first = [f"[{BRAND}]{model}[/]"]
    if usage:
        first.append(" ".join(usage))
    first.append(
        f"[dim]ctx {ctx_text}"
        f" ↑{compact(context.get("total_input_tokens"))}"
        f" ↓{compact(context.get("total_output_tokens"))}[/]"
    )

    host = os.uname().nodename
    second = [f"[{host_style(host)}]{host}[/]"]
    if session := data.get("session_name"):
        second.append(f"[dim]{escape(session)}[/]")
    if changes := working_copy():
        second.append(changes)

    console = Console(color_system="truecolor", force_terminal=True,
                      soft_wrap=True, highlight=False, emoji=False)
    console.print(SEPARATOR.join(first))
    console.print(SEPARATOR.join(second), end="")


if __name__ == "__main__":
    main()
