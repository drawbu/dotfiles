from libqtile import qtile
from libqtile.widget import base


class TextWidget(base._TextBox):
    def __init__(
        self, 
        name: str = "TextWidget", 
        text: str = "", 
        callbacks = None,
        **config
    ):
        super().__init__(text, qtile=qtile, **config)
        self.name = name
        if callbacks != None:
            self.add_callbacks(callbacks)


class LoopWidget(base.ThreadPoolText):
    def __init__(
        self, 
        name: str = "LoopWidget", 
        text: str = "", 
        callbacks = None,
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
        if callbacks != None:
            self.add_callbacks(callbacks)
