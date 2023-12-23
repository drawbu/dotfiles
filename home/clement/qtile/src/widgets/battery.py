from enum import Enum
from typing import Optional
from typing_extensions import Self

from utils import (
    get_stdout, LoopWidget, notify, 
    GOOD_COLOR, TEXT_COLOR, WARN_COLOR
)


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


class Battery(LoopWidget):
    def __init__(self):
        LoopWidget.__init__(self, name="Battery")
        battery = self.__get_device()
        if battery is None:
            return
        self.battery = BatteryState(battery)
        self.text_color = TEXT_COLOR
        self.warn_color = WARN_COLOR
        self.good_color = GOOD_COLOR
        self.__has_warned = False

    def __get_device(self) -> Optional[str]:
        devices = get_stdout(["upower", "-e"])
        if devices == "":
            return None
        for dev in devices.split("\n"):
            if dev.startswith("/org/freedesktop/UPower/devices/battery_"):
                return dev
        return None

    def __warn(self) -> None:
        percentage = self.battery.percentage
        if percentage is None:
            return
        if percentage > 20:
            self.__has_warned = False
            return
        if self.__has_warned == True:
            return
        self.__has_warned = True
        notify(f"Warning: Battery is low: {percentage}%")


    def poll(self) -> str:
        self.battery.refresh()
        state = self.battery.state
        percentage = self.battery.percentage
        if state is None or percentage is None:
            notify("Something went wrong with the battery widget.")
            return ""
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
        self.__warn()
        return f"<span foreground='#{color}'>{text}</span>"
