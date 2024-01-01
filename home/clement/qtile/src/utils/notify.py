from libqtile import qtile


def notify(text: str) -> None:
    qtile.spawn(f"notify-send \"{text}\"")
