from libqtile import widget


class Separator(widget.Sep):
    def __init__(self, padding: int = 4, linewidth: int = 0, **config):
        super().__init__(padding=padding, linewidth=linewidth, **config)
        self.name = "Separator widget"
