from libqtile.config import Screen

from .bar import Bar


screens = [
    Screen(
        wallpaper="~/assets/wallpaper.jpg",
        wallpaper_mode="fill",
        bottom=Bar(True),
    ),
    Screen(
        wallpaper="~/assets/wallpaper.jpg",
        wallpaper_mode="fill",
        bottom=Bar(False),
    ),
]
