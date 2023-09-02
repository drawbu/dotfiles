from libqtile import qtile
from libqtile.widget import base


class TextWidget(base._TextBox):
    def __init__(self, name="", text="", **config):
        super().__init__(text, qtile=qtile, **config)
        self.name = name
