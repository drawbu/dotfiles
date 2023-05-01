from typing import List

from libqtile import bar, widget
from libqtile.config import Screen


class CustomBar(bar.Bar):
    def __init__(self, is_primary: bool):
        widgets: List[widget.base._Widget] = [
            widget.CurrentLayout(),
            widget.GroupBox(),
            widget.Prompt(),
            widget.WindowName(),
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
        ]

        if is_primary:
            widgets.append(widget.Systray())

        widgets.extend([
            widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
            widget.QuickExit(),
        ])
        super().__init__(widgets=widgets, size=24)


screens = [
    Screen(
        wallpaper="~/assets/wallpaper.jpg",
        wallpaper_mode="fill",
        bottom=CustomBar(True),
    ),

    Screen(
        wallpaper="~/assets/wallpaper.jpg",
        wallpaper_mode="fill",
        bottom=CustomBar(False),
    )
]
