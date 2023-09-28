from typing import Final

from catppuccin import Flavour


flavour = Flavour.mocha()

BACKGROUND_COLOR = flavour.base.hex
TEXT_COLOR = flavour.text.hex
PRIMARY_COLOR = flavour.peach.hex
INACTIVE_COLOR = flavour.surface1.hex
FADED_COLOR = flavour.surface0.hex


TERMINAL: Final[str] = "kitty"
META: Final[str] = "mod4"  # Super key (Windows key)


widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=3,
    foreground=TEXT_COLOR,
)
