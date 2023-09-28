from typing import Optional

from utils import get_stdout
from utils.widgets import LoopWidget


def has_battery():
    return get_stdout(["upower", "-e"]) != ""


class BatteryState():
    state: Optional[str] = None
    percentage: Optional[str] = None
    time_to_full: Optional[str] = None
    sec_to_empty: Optional[str] = None

    def __init__(self, battery: str):
        self.battery = battery

    def reset_vars(self):
        self.state = None
        self.percentage = None
        self.time_to_full = None
        self.sec_to_empty = None

    def refresh(self) -> None:
        self.reset_vars()
        raw = get_stdout(["upower", "--show-info", self.battery])
        if raw == "":
            return
        for line in raw.split("\n"):
            tokens = line.split(":")
            if len(tokens) < 2:
                continue
            var = tokens[0].strip()
            value = tokens[1].strip()
            if var == "state":
                self.state = value
                continue
            if var == "percentage":
                self.percentage = value
                continue
            if var == "time to full":
                self.time_to_full = value
                continue


class Battery(LoopWidget):
    def __init__(self):
        super().__init__(name="Battery")
        battery = self.__get_device()
        if battery is None:
            return
        self.battery = BatteryState(battery)

    def __get_device(self) -> Optional[str]:
        devices = get_stdout(["upower", "-e"])
        if devices == "":
            return None
        for dev in devices.split("\n"):
            if dev.startswith("/org/freedesktop/UPower/devices/battery_"):
                return dev
        return None

    def poll(self) -> str:
        self.battery.refresh()
        state = self.battery.state
        percentage = self.battery.percentage
        if state is None or percentage is None:
            return ""
        battery_icon = " " if state == "discharging" else " "
        arrow_icon = (
            "󰁞" if state == "charging" else
            "󰁆" if state == "discharging" else
            ""
        )
        return f"{battery_icon} {percentage} {arrow_icon}"
