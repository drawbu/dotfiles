from libqtile import layout
from libqtile.config import Match

layouts = [
    layout.Tile(margin=3, shift_windows=True, name="Tile", add_on_top=False),
    layout.Floating(name="Float"),
]


floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
    ]
)