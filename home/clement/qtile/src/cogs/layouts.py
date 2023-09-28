from libqtile import layout
from libqtile.config import Match

from utils import (
    PRIMARY_COLOR,
    INACTIVE_COLOR,
)


layouts = [
    layout.Tile(
        margin=3,
        shift_windows=True,
        name="Tile",
        add_on_top=False,
        border_focus=PRIMARY_COLOR,
        normal_border=INACTIVE_COLOR,
    ),
    layout.Floating(
        name="Float", border_focus=PRIMARY_COLOR, normal_border=INACTIVE_COLOR
    ),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(title="kitty"),
    ],
    border_focus=PRIMARY_COLOR,
    normal_border=INACTIVE_COLOR,
)
