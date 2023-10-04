from libqtile import qtile


def notify(text: str) -> None:
    qtile.cmd_spawn(f"notify-send \"{text}\"")
