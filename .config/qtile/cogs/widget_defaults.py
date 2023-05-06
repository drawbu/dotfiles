from plugins.catppuccin import Flavour


flavour = Flavour.mocha()

BACKGROUND_COLOR = flavour.base.hex
TEXT_COLOR = flavour.text.hex
PRIMARY_COLOR = flavour.peach.hex
INACTIVE_COLOR = flavour.surface1.hex


widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=3,
    foreground=TEXT_COLOR,
)
