from libqtile.config import Key
from libqtile.lazy import lazy


terminal = "kitty"
META = "mod4"  # Super key (Windows key)


keys = [
    Key([META], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([META], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([META, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([META, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([META], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Take a screenshot"),
]
