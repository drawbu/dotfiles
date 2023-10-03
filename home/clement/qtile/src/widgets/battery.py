from enum import Enum
from typing import Optional
from typing_extensions import Self

from qtile_extras.widget.mixins import TooltipMixin

from utils import get_stdout, LoopWidget
from utils.defaults import GOOD_COLOR, TEXT_COLOR, WARN_COLOR


def has_battery():
    return get_stdout(["upower", "-e"]) != ""


class ChargeState(Enum):
    unknown = 0
    charging = 1
    discharging = 2
    full = 3

    @classmethod
    def from_string(cls, value: str) -> Self:
        if value == "charging":
            return cls.charging
        if value == "discharging":
            return cls.discharging
        if value == "full":
            return cls.full
        return cls.unknown


class BatteryState():
    state: Optional[ChargeState] = None
    percentage: Optional[int] = None
    time_to_full: Optional[str] = None
    sec_to_empty: Optional[str] = None

    def __init__(self, battery: str):
        self.battery = battery

    def reset_vars(self):
        self.state = None
        self.percentage = None
        self.time_to_full = None
        self.time_to_empty = None

    def refresh(self) -> None:
        self.reset_vars()
        raw = get_stdout(["upower", "--show-info", self.battery])
        if raw == "":
            return
        for line in raw.split("\n"):
            tokens = line.split(":")
            if len(tokens) < 2:
                continue
            name = tokens[0].strip()
            value = tokens[1].strip()
            if name == "state":
                self.state = ChargeState.from_string(value)
                continue
            if name == "percentage":
                try:
                    self.percentage = int(value[:-1])
                except ValueError:
                    pass
                continue
            if name == "time to full":
                self.time_to_full = value
                continue
            if name == "time to empty":
                self.time_to_empty = value
                continue


class Battery(LoopWidget, TooltipMixin):
    def __init__(self):
        LoopWidget.__init__(self, name="Battery")
        TooltipMixin.__init__(self)
        self.add_defaults(TooltipMixin.defaults)
        battery = self.__get_device()
        if battery is None:
            return
        self.battery = BatteryState(battery)
        self.tooltip_text = ""
        self.text_color = TEXT_COLOR
        self.warn_color = WARN_COLOR
        self.good_color = GOOD_COLOR

    def __get_device(self) -> Optional[str]:
        devices = get_stdout(["upower", "-e"])
        if devices == "":
            return None
        for dev in devices.split("\n"):
            if dev.startswith("/org/freedesktop/UPower/devices/battery_"):
                return dev
        return None

    def __set_tooltip(self) -> None:
        state = self.battery.state
        if state == ChargeState.full:
            self.tooltip_text = f"The battery is full"
        time_to_full = self.battery.time_to_full
        if time_to_full is not None and state == ChargeState.charging:
            self.tooltip_text = f"{time_to_full} left to full"
            return
        time_to_empty = self.battery.time_to_empty
        if time_to_empty is not None and state == ChargeState.discharging:
            self.tooltip_text = f"{time_to_empty} left on battery"
            return
        self.tooltip_text = ""

    def poll(self) -> str:
        self.battery.refresh()
        state = self.battery.state
        percentage = self.battery.percentage
        if state is None or percentage is None:
            return ""
        self.__set_tooltip()
        arrow_icon = (
            "󰁞" if state == ChargeState.charging else
            "󰁆" if state == ChargeState.discharging else
            ""
        )
        battery_icon = " " if state == ChargeState.discharging else " "
        text = f"{battery_icon} {percentage}% {arrow_icon}"
        color = (
            self.warn_color if percentage <= 10 else 
            self.good_color if percentage >= 100 else 
            self.text_color
        )
        return f"<span foreground='#{color}'>{text}</span>"
