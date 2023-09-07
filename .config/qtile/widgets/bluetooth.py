import subprocess

from libqtile import qtile
from libqtile.lazy import lazy
from libqtile.widget import base


class Bluetooth(base.InLoopPollText):
    def __init__(self, **config):
        super().__init__("", name="Bluetooth", update_interval=10, qtile=qtile, **config)
        self.add_callbacks({
            "Button1": self.open_bluetooth_manager(),
        })

    def open_bluetooth_manager(self) -> None:
        return lazy.spawn("rofi-bluetooth")

    def poll(self) -> str:
        try:
            proc = subprocess.Popen(
                ["bluetoothctl", "devices", "Connected"],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
            )
        except FileNotFoundError:
            return "󰂲 "
        stdout, stderr = proc.communicate()
        if stderr is not None or proc.returncode != 0:
            return "󰂲 "
        count = stdout.decode("utf-8").count("\n")
        if count == 0:
            return "󰂯 "
        return f"󰂯 {count}"
