import os
import os.path
import random
from typing import Final

from libqtile.config import Screen

from .bar import Bar


def choose_wallpaper() -> str:
    collection = f"{WALLPAPERS_FOLDER }/minimalistic-wallpaper-collection/images"
    if os.path.isdir(collection):
        return f"{collection}/{random.choice(os.listdir(collection))}"
    return f"{WALLPAPERS_FOLDER}/wallpaper.jpg"

WALLPAPERS_FOLDER = os.path.expanduser("~/assets/wallpapers")
WALLPAPER: Final[str] = f"{WALLPAPERS_FOLDER}/anime-girl.jpeg"

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
