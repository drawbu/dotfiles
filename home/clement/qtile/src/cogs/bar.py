from typing import Iterable, List, Optional

from libqtile import bar, widget

from widgets import (
    Wakatime, Separator, Wifi, SpotifyNowPlaying, SpotifyCover,
    Bluetooth,
)
from utils import (
    TextWidget, 
    get_stdout,
    TEXT_COLOR,
    PRIMARY_COLOR,
    INACTIVE_COLOR,
    BACKGROUND_COLOR,
    FADED_COLOR,
)


WidgetType = widget.base._Widget


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
        ]
        # Right part
        if self.is_primary:
            widgets += self.__get_spotify_widgets()
        widgets += [
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

    def sep(self, width: Optional[int] = None) -> WidgetType:
        return Separator(padding=self.__sep_width if width is None else width)

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
        ] + self.__get_brightness_widgets() + [
            Bluetooth(),
            TextWidget("Pipe", "|", foreground=PRIMARY_COLOR),
        ]))
    
    def __get_battery_widgets(self) -> List[WidgetType]:
        return [
            widget.Battery(
                show_short_text=False,
                format="{char} {percent:2.0%}",
                full_char=" ",
                charge_char=" ",
                discharge_char=' ',
                notify_below=20,
                notification_timeout=30,
                update_interval=5
            ),
            widget.Battery(
                show_short_text=False,
                format="{char}",
                full_char="",
                charge_char="󰁞",
                discharge_char='󰁆',
                update_interval=5
            ),
            self.sep(),
        ] if get_stdout(["upower", "-e"]) != "" else []

    def __get_brightness_widgets(self) -> List[WidgetType]:
        stdout = get_stdout(["brightnessctl", "-m"])
        if stdout == "":
            return []
        status = stdout.split(",")
        return [
            widget.Backlight(backlight_name=status[0], fmt=" {}")
        ] if len(status) >= 2 and status[1] == "backlight" else []

    def __get_spotify_widgets(self) -> List[WidgetType]:
        cover = SpotifyCover()
        return [
            SpotifyNowPlaying(cover),
            self.sep(self.__sep_width // 2),
            cover,
            self.sep(),
        ]
