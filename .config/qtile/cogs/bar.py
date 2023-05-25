from typing import List

from libqtile import bar, widget

from plugins.catppuccin import Flavour
from widgets import Wakatime, Separator
from .widget_defaults import (
    TEXT_COLOR,
    PRIMARY_COLOR,
    INACTIVE_COLOR,
    BACKGROUND_COLOR
)

flavour = Flavour.mocha()


class Bar(bar.Bar):
    def __init__(self, is_primary: bool):
        separators_width: int = 15

        widgets: List[widget.base._Widget] = [
            widget.CurrentLayout(),
            widget.GroupBox(
                other_screen_border=INACTIVE_COLOR,
                other_current_screen_border=PRIMARY_COLOR,
                this_screen_border=INACTIVE_COLOR,
                this_current_screen_border=PRIMARY_COLOR,
                block_highlight_text_color=TEXT_COLOR,
                active=TEXT_COLOR,
                inactive=INACTIVE_COLOR,
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
            widget.CheckUpdates(
                distro="Arch_yay",
                no_update_string="",
                display_format="{updates} 󰏗",
                colour_have_updates=TEXT_COLOR,
            ),
            Separator(padding=separators_width),
        ]

        if is_primary:
            widgets.extend([widget.Systray(), Separator(padding=separators_width)])

        widgets.extend(
            [
                widget.Clock(format="%a %I:%M %p"),
                widget.QuickExit(),
            ]
        )
        super().__init__(widgets=widgets, size=24, background=BACKGROUND_COLOR)
