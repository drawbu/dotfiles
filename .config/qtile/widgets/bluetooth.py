import subprocess

from libqtile import qtile
from libqtile.lazy import lazy
from libqtile.widget import base


class Bluetooth(base.ThreadPoolText):
    def __init__(self, **config):
        super().__init__("󰂲 ", name="Bluetooth", update_interval=10, qtile=qtile, **config)
        self.add_callbacks({
            "Button1": self.open_bluetooth_manager(),
        })

    def open_bluetooth_manager(self) -> None:
        return lazy.spawn("rofi-bluetooth")

    def poll(self) -> str:
        try:
            proc = subprocess.run(
                ["bluetoothctl", "devices", "Connected"],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=1,
            )
        except (FileNotFoundError, TimeoutError):
            return "󰂲 "
        if proc.stderr is not None or proc.returncode != 0:
            return "󰂲 "
        devices_count = proc.stdout.decode("utf-8").count("\n")
        return f"󰂯 {devices_count or ''}"
