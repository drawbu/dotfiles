import subprocess

from libqtile import qtile
from libqtile.widget import base


class Wakatime(base.ThreadPoolText):
    def __init__(self, **config):
        super().__init__("", update_interval=600, qtile=qtile, **config)
        self.name = "Wakatime widget"

    def poll(self) -> str:
        try:
            proc = subprocess.run(
                ["wakatime-cli", "--today"],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=1,
            )
        except (FileNotFoundError, TimeoutError):
            return ""
        if proc.stderr is not None:
            return ""
        return " ".join(proc.stdout.decode("utf-8").split())
