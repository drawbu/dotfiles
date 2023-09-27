from libqtile import widget, qtile


class Separator(widget.Sep):
    def __init__(self, padding: int = 4, **config):
        super().__init__(padding=padding, linewidth=0, qtile=qtile, **config)
        self.name = "Separator widget"
