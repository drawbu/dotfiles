import subprocess

from libqtile import qtile
from libqtile.lazy import lazy
from libqtile.widget import base

class NetworkError(Exception):
    def __init__(self, message: str):
        super().__init__(message)

class NetworkState:
    def __init__(self):
        self.wifi: bool = False
        self.ethernet: bool = False
        self.refresh()

    def refresh(self) -> None:
        self.wifi = False
        self.ethernet = False
        try:
            proc = subprocess.run(
                ['nmcli', 'connection', 'show', '--active'],
                stdout=subprocess.PIPE,
                timeout=1,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired):
            return
        lines = proc.stdout.decode("utf-8").split("\n")
        if len(lines) < 2:
            return
        type_index = lines[0].find("TYPE")
        device_index = lines[0].find("DEVICE")
        if type_index == -1 and device_index == -1 and type_index > device_index:
            return
        for line in lines[1:]:
            if len(line) < device_index:
                continue
            connection_type = line[type_index:device_index].strip()
            if connection_type == "ethernet":
                self.ethernet = True
                continue
            if connection_type == "wifi":
                self.wifi = True
                continue


class Wifi(base.ThreadPoolText):
    def __init__(self, **config):
        super().__init__("", update_interval=10, qtile=qtile, **config)
        self.name = "Wifi widget"
        self.__connected = False
        self.__state = NetworkState()
        self.add_callbacks({
            "Button1": self.open_network_manager(),
        })

    @property
    def connected(self) -> bool:
        return self.__connected

    @connected.setter
    def connected(self, value: bool) -> None:
        if self.__connected and not value:
            qtile.cmd_spawn("notify-send 'Disconnected from network'")
        self.__connected = value

    def open_network_manager(self) -> None:
        return lazy.spawn("kitty -e nmtui")

    def poll(self) -> str:
        try:
            self.__state.refresh()
        except NetworkError:
            self.connected = False
            return "󰖪 "
        if self.__state.ethernet:
            self.connected = True
            return "󰈀 "
        if self.__state.wifi:
            self.connected = True
            return " "
        self.connected = False
        return "󰤯 "
