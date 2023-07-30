import subprocess

from libqtile import qtile
from libqtile.widget import base


class Wifi(base.InLoopPollText):
    def __init__(self, **config):
        super().__init__("", update_interval=10, qtile=qtile, **config)
        self.name = "Wifi widget"

    def poll(self) -> str:
        try:
            proc = subprocess.Popen(
                ['nmcli', 'connection', 'show', '--active'],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
            )
        except FileNotFoundError:
            return "󰖪 "
        stdout, stderr = proc.communicate()
        if stderr is not None:
            return "󰖪 "
        lines = stdout.decode("utf-8").split("\n")
        if len(lines) < 2:
            return "󰖪 "
        type_index = lines[0].find("TYPE")
        device_index = lines[0].find("DEVICE")
        if type_index == -1 and device_index == -1 and type_index > device_index:
            return "󰖪 "
        for line in lines[1:]:
            if len(line) < device_index:
                continue
            connection_type = line[type_index:device_index].strip()
            if connection_type == "ethernet":
                return "󰈀 "
            if connection_type == "wifi":
                return " "
        return "󰤯 "
