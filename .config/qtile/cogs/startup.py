import subprocess
import os

from libqtile import hook


SCRIPT_PATH = "~/autostart.sh"


@hook.subscribe.startup_once
def autostart():
    if not os.path.exists(SCRIPT_PATH):
        return
    home = os.path.expanduser(SCRIPT_PATH)
    subprocess.call([home])
