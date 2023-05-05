import subprocess
import os

from libqtile import hook, qtile

SCRIPT_PATH = "~/startup.sh"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser(SCRIPT_PATH)
    if not os.path.exists(home):
        return
    result = subprocess.call(["sh", home])
    if result == 1:
        qtile.cmd_spawn("notify-send 'Error while starting'")
        return
    qtile.cmd_spawn("notify-send 'Started with success'")
