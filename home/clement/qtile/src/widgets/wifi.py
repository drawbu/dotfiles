from libqtile import qtile
from libqtile.lazy import lazy

from utils import LoopWidget, get_stdout


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
        stdout = get_stdout(['nmcli', 'connection', 'show', '--active'])
        if stdout == "":
            return
        lines = stdout.split("\n")
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


class Wifi(LoopWidget):
    def __init__(self):
        super().__init__(name="Wifi widget", callbacks={
            "Button1": lazy.spawn("kitty -e nmtui"),
        })
        self.__connected = False
        self.__state = NetworkState()

    @property
    def connected(self) -> bool:
        return self.__connected

    @connected.setter
    def connected(self, value: bool) -> None:
        if self.__connected and not value:
            qtile.cmd_spawn("notify-send 'Disconnected from network'")
        self.__connected = value

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
