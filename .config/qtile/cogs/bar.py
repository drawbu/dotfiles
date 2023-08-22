from typing import List
import subprocess

from libqtile import bar, widget

from widgets import Wakatime, Separator, Wifi
from .widget_defaults import (
    TEXT_COLOR,
    PRIMARY_COLOR,
    INACTIVE_COLOR,
    BACKGROUND_COLOR,
    FADED_COLOR,
)

WidgetType = widget.base._Widget


def has_battery() -> bool:
        try:
            proc = subprocess.run(["upower", "-e"])
        except FileNotFoundError:
            return False
        return proc.returncode == 0


class Bar(bar.Bar):
    def __init__(self, is_primary: bool):
        self.__sep_width: int = 15

        box_items : List[WidgetType] = [
            self.sep(),
            widget.QuickExit(default_text='[X]', countdown_format='[{}]'),
            self.sep(),
        ]

        if is_primary:
            box_items = [
                self.sep(),
                widget.Systray(),
            ] + box_items

        battery_widgets: List[WidgetType] = []

        if has_battery():
            battery_widgets = [
                widget.Battery(show_short_text=False, foreground="#FFFFFF", format="{char}", full_char=" ", charge_char=" ", discharge_char = ' ', update_interval=5),
                widget.Battery(show_short_text=False, format="{percent:2.0%}", notify_below = 30, notification_timeout = 0, update_interval=5),
                widget.Battery(show_short_text=False, format="{char}", full_char="", charge_char="󰁞", discharge_char = '󰁆', update_interval=5),
                self.sep(),
            ]


        widgets: List[WidgetType] = [
            # Left part
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

            # Middle part
            self.sep(),
            widget.TaskList(
                highlight_method="block",
                border=INACTIVE_COLOR,
                rounded=False,
                max_title_width=200,
                txt_floating="󱂬 ",
                txt_minimized="󰖰 ",
            ),
            self.sep(),

            # Right part
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            Wakatime(),
            self.sep(),
        ] + battery_widgets + [
            Wifi(),
            self.sep(),
            widget.PulseVolume(),
            self.sep(),
            widget.Clock(format="%A, %b %-d"),
            self.sep(),
            widget.Clock(markup=True, format="<span foreground='#FFFFFF'>󰥔 </span>%I:%M %p"),
            self.sep(),
            widget.WidgetBox(
                widgets=box_items,
                foreground=PRIMARY_COLOR,
                text_closed=" ",
                text_open="  ",
                close_button_location="right",
            ),
            self.sep(),
        ]

        super().__init__(widgets=widgets, size=24, background=BACKGROUND_COLOR + "F3")

    def sep(self):
        return Separator(padding=self.__sep_width)
