from libqtile.config import Key
from libqtile.lazy import lazy


terminal = "kitty"
META = "mod4"  # Super key (Windows key)


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    Key([META], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([META], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([META], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([META], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([META], "s", lazy.next_layout(), desc="Toggle between layouts"),
    Key([META], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([META, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([META, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([META], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Take a screenshot"),
]
