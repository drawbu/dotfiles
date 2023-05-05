from typing import List

from libqtile import bar, widget, qtile
from libqtile.config import Screen

from widgets import Wakatime, Separator


class CustomBar(bar.Bar):
    def __init__(self, is_primary: bool):
        separators_width: int = 10

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
            widgets.extend([
                widget.Systray(),
                Separator(qtile=qtile, padding=separators_width)
            ])

        widgets.extend([
            Wakatime(qtile=qtile),
            Separator(qtile=qtile, padding=separators_width),
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
