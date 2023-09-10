from typing import List, Optional
import subprocess
import urllib.request

from libqtile import qtile, widget
from libqtile.widget import base


COVER_PATH = "/tmp/spotify-now-playing.png"


def get_stdout(cmd: List[str]) -> str:
    try:
        sub = subprocess.run(cmd, stdout=subprocess.PIPE, timeout=1)
    except (FileNotFoundError, TimeoutError):
        return ""
    return sub.stdout.decode("utf-8").strip()


class SpotifyCover(widget.Image):
    def __init__(self, **config):
        super().__init__(filename=COVER_PATH, **config)
        self.name = "Spotify cover"
        self.filename: Optional[str] = None
        self.__last_cover: Optional[str] = None

    def update_cover(self) -> None:
        if self.filename is None:
            self.img = None
            self.bar.draw()
            return

        cover_url = get_stdout(["playerctl", "--player=spotify", "metadata", "mpris:artUrl"])
        if cover_url == "":
            self.__cover.remove_cover()
            return
        if cover_url == self.__last_cover:
            return
        self.__last_cover = cover_url
        urllib.request.urlretrieve(cover_url, self.filename)

        old_length = self.calculate_length()
        self._update_image()

        if self.calculate_length() == old_length:
            self.draw()
        else:
            self.bar.draw()

    def remove_cover(self) -> None:
        self.filename = None
        self.__last_cover = None
        self.update_cover()


class SpotifyNowPlaying(base.ThreadPoolText):
    def __init__(self, cover: SpotifyCover, **config):
        super().__init__("", update_interval=5, qtile=qtile, **config)
        self.name = "Spotify now playing"
        self.__cover = cover

    def poll(self) -> str:
        is_playing = get_stdout(["playerctl", "--player=spotify", "status"])
        if is_playing != "Playing":
            self.__cover.remove_cover()
            return ""
        artist = get_stdout(["playerctl", "--player=spotify", "metadata", "artist"])
        title = get_stdout(["playerctl", "--player=spotify", "metadata", "title"])
        if artist == "" or title == "":
            self.__cover.remove_cover()
            return ""
        if self.__cover.filename is None:
            self.__cover.filename = COVER_PATH
        self.__cover.update_cover()
        return f" {artist} - {title}"
