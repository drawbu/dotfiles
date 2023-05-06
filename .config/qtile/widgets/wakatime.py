import subprocess

from libqtile import qtile
from libqtile.widget import base


class Wakatime(base.InLoopPollText):
    def __init__(self, **config):
        super().__init__("", update_interval=600, qtile=qtile, **config)
        self.name = "Wakatime widget"

    def poll(self) -> str:
        try:
            proc = subprocess.Popen(
                ["wakatime", "--today"],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
            )
        except FileNotFoundError:
            return ""
        stdout, stderr = proc.communicate()
        if stderr is not None:
            return ""
        return " ".join(stdout.decode("utf-8").split())
