from typing import List

from libqtile import bar, widget

from plugins.catppuccin import Flavour
from widgets import Wakatime, Separator, Wifi
from .widget_defaults import (
    TEXT_COLOR,
    PRIMARY_COLOR,
    INACTIVE_COLOR,
    BACKGROUND_COLOR,
    FADED_COLOR,
)

flavour = Flavour.mocha()


class Bar(bar.Bar):
    def __init__(self, is_primary: bool):
        separators_width: int = 15

        widgets: List[widget.base._Widget] = [
            widget.CurrentLayout(),
            widget.GroupBox(
                borderwidth=0,
                highlight_method="block",
                padding=8,
                disable_drag=True,
                use_mouse_wheel=False,
                active=TEXT_COLOR,
                inactive=INACTIVE_COLOR,
                # Primary screen
                this_current_screen_border=INACTIVE_COLOR,
                other_screen_border=FADED_COLOR,
                # Other screens
                other_current_screen_border=FADED_COLOR,
                this_screen_border=INACTIVE_COLOR,
            ),
            widget.Prompt(bell_style="visual"),
            widget.TaskList(
                border=PRIMARY_COLOR,
                unfocused_border=INACTIVE_COLOR,
            ),
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            Wakatime(),
            Separator(padding=separators_width),
            widget.Battery(format="{char} {percent:2.0%} {hour:d}:{min:02d}"),
            Separator(padding=separators_width),
            Wifi(),
            Separator(padding=separators_width),
            widget.PulseVolume(),
        ]

        if is_primary:
            widgets.extend([widget.Systray(), Separator(padding=separators_width)])

        widgets.extend(
            [
                widget.Clock(format="%a %I:%M %p"),
                Separator(padding=separators_width),
            ]
        )
        super().__init__(widgets=widgets, size=24, background=BACKGROUND_COLOR + "F3")
