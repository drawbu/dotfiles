from utils import LoopWidget, get_stdout


class Wakatime(LoopWidget):
    def __init__(self):
        super().__init__(update_interval=600, name="Wakatime")

    def poll(self) -> str:
        return " ".join(get_stdout(["wakatime-cli", "--today"]).split())
