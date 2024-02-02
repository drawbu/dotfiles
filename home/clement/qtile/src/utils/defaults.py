from typing import Final

from catppuccin import Flavour


FLAVOUR = Flavour.mocha()

BACKGROUND_COLOR = FLAVOUR.base.hex
TEXT_COLOR = FLAVOUR.text.hex
PRIMARY_COLOR = FLAVOUR.peach.hex
INACTIVE_COLOR = FLAVOUR.surface1.hex
FADED_COLOR = FLAVOUR.surface0.hex
WARN_COLOR = FLAVOUR.red.hex
GOOD_COLOR = FLAVOUR.green.hex


TERMINAL: Final[str] = "kitty"
META: Final[str] = "mod4"  # Super key (Windows key)


widget_defaults = dict(
    font="Iosevka Nerd Font",
    fontsize=13,
    padding=3,
    foreground=TEXT_COLOR,
)
