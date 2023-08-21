from typing import Final

from libqtile.config import Key
from libqtile.lazy import lazy


TERMINAL: Final[str] = "kitty"
META: Final[str] = "mod4"  # Super key (Windows key)


keys = [
    Key([META], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key([META], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([META, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([META, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([META], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Take a screenshot"),
    Key([META, "control"], "space", lazy.spawn("rofi -show drun"), desc="Open rofi"),
    # Layout
    Key([META], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([META], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key(
        [META, "control"],
        "Right",
        lazy.layout.increase_ratio(),
        desc="Increase active window size.",
    ),
    Key(
        [META, "control"],
        "Left",
        lazy.layout.decrease_ratio(),
        desc="Decrease active window size.",
    ),
    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    # Volume
    Key([], "XF86AudioMute", lazy.spawn("pamixer --toggle-mute")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer --decrease 5")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer --increase 5")),
]
