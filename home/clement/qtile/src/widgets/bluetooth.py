from libqtile.lazy import lazy

from utils import LoopWidget, get_stdout


class Bluetooth(LoopWidget):
    def __init__(self):
        super().__init__(text="󰂲 ", name="Bluetooth", callbacks={
            "Button1": lazy.spawn("rofi-bluetooth"),
        })


    def poll(self) -> str:
        stdout = get_stdout(["bluetoothctl", "devices", "Connected"])
        if stdout == "":
            return "󰂲 "
        devices_count = stdout.count("\n")
        return f"󰂯 {devices_count or ''}"
