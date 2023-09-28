from libqtile.config import Drag
from libqtile.lazy import lazy

from utils import META


# Drag floating layouts.
mouse = [
    Drag(
        [META],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [META], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
]
