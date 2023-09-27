from libqtile.lazy import lazy

from utils import LoopWidget, get_stdout


class Bluetooth(LoopWidget):
    def __init__(self):
        super().__init__(text="󰂲 ", name="Bluetooth")
        self.add_callbacks({
            "Button1": self.open_bluetooth_manager(),
        })

    def open_bluetooth_manager(self) -> None:
        return lazy.spawn("rofi-bluetooth")

    def poll(self) -> str:
        stdout = get_stdout(["bluetoothctl", "devices", "Connected"])
        if stdout == "":
            return "󰂲 "
        devices_count = stdout.count("\n")
        return f"󰂯 {devices_count or ''}"
