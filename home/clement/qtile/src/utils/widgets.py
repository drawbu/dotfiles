from libqtile import qtile
from libqtile.widget import base


class TextWidget(base._TextBox):
    def __init__(
        self, 
        name: str = "TextWidget", 
        text: str = "", 
        **config
    ):
        super().__init__(text, qtile=qtile, **config)
        self.name = name


class LoopWidget(base.ThreadPoolText):
    def __init__(
        self, 
        name: str = "LoopWidget", 
        text: str = "", 
        update_interval: int = 10, 
        **config
    ):
        super().__init__(
            text, 
            name=name, 
            update_interval=update_interval, 
            qtile=qtile, 
            **config
        )
        self.name = name
