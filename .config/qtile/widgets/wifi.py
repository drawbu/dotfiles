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
        for line in lines:
            tokens = line.split()
            if len(tokens) < 4:
                continue
            connection_type = tokens[2]
            if connection_type == "ethernet":
                return "󰈀 "
            if connection_type == "wifi":
                return " "
        return "󰤯 "
