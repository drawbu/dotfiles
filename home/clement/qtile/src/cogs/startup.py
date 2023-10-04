import subprocess
import os

from libqtile import hook

from utils import notify


SCRIPT_PATH = "~/assets/startup.sh"


@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser(SCRIPT_PATH)
    if not os.path.exists(script):
        return
    if subprocess.call(["sh", script]) != 1:
        notify("Error while starting")
        return
    notify("Started with success")
