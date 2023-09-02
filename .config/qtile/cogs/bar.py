from typing import Iterable, List
import subprocess

from libqtile import bar, widget, qtile
from libqtile.widget import base

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


class TextWidget(base._TextBox):
    def __init__(self, name="", text="", **config):
        super().__init__(text, qtile=qtile, **config)
        self.name = name


class Bar(bar.Bar):
    def __init__(self, is_primary: bool):
        self.is_primary = is_primary
        self.__sep_width: int = 15

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
        ] + self.__get_battery_widgets() + [
            Wifi(),
            self.sep(),
            widget.Clock(format="%A, %b %-d"),
            self.sep(),
            widget.Clock(markup=True, format="<span foreground='#FFFFFF'>󰥔 </span>%I:%M %p"),
            self.sep(),
        ]
        if self.is_primary:
            widgets += [
                widget.WidgetBox(
                    widgets=self.__get_box_items(),
                    foreground=PRIMARY_COLOR,
                    text_closed=" ",
                    text_open="  ",
                    close_button_location="right",
                    ),
                self.sep(),
            ]

        super().__init__(widgets=widgets, size=24, background=BACKGROUND_COLOR + "F3")

    def sep(self) -> WidgetType:
        return Separator(padding=self.__sep_width)

    def __add_seps(self, widgets: Iterable[WidgetType]) -> List[WidgetType]:
        result = []
        for w in widgets:
            result.extend([w, self.sep()])
        return result
    
    def __get_box_items(self) -> List[WidgetType]:
        return self.__add_seps(reversed([
            widget.QuickExit(default_text='[X]', countdown_format='[{}]'),
            widget.Systray(),
            widget.PulseVolume(fmt='󰕾 {}'),
            TextWidget("Pipe", "|", foreground=PRIMARY_COLOR),
        ]))
    
    def __get_battery_widgets(self) -> List[WidgetType]:
        return [
            widget.Battery(show_short_text=False, foreground="#FFFFFF", format="{char}", full_char=" ", charge_char=" ", discharge_char = ' ', update_interval=5),
            widget.Battery(show_short_text=False, format="{percent:2.0%}", notify_below = 30, notification_timeout = 0, update_interval=5),
            widget.Battery(show_short_text=False, format="{char}", full_char="", charge_char="󰁞", discharge_char = '󰁆', update_interval=5),
            self.sep(),
        ] if has_battery() else []
