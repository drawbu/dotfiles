import os
import os.path
import random
from typing import Final

from libqtile.config import Screen

from .bar import Bar


def choose_wallpaper() -> str:
    folder = os.path.expanduser("~/assets/wallpapers")
    collection = f"{folder}/minimalistic-wallpaper-collection/images"
    if os.path.isdir(collection):
        return f"{collection}/{random.choice(os.listdir(collection))}"
    return f"{folder}/wallpaper.jpg"

WALLPAPER: Final[str] = choose_wallpaper()

screens = [
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
        bottom=Bar(True),
    ),
    Screen(
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
        bottom=Bar(False),
    ),
]
