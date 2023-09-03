from typing import List
import subprocess
import urllib.request

from libqtile import qtile
from libqtile import widget
from libqtile.widget import base


class SpotifyNowPlaying(base.InLoopPollText):
    def __init__(self, cover: widget.Image, **config):
        super().__init__("", update_interval=10, qtile=qtile, **config)
        self.name = "Spotify now playing"
        self.__last_cover = None
        self.__cover_path = "/tmp/spotify-now-playing.png"
        self.__cover = cover

    def __run_cmd(self, cmd: List[str]) -> str:
        try:
            sub = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        except FileNotFoundError:
            return ""
        return sub.communicate()[0].decode("utf-8").strip()

    def __get_cover(self):
        cover_url = self.__run_cmd(["playerctl", "--player=spotify", "metadata", "mpris:artUrl"])
        if cover_url == "" or cover_url == self.__last_cover:
            return
        self.__last_cover = cover_url
        urllib.request.urlretrieve(cover_url, self.__cover_path)
        self.__cover.cmd_update(self.__cover_path)

    def poll(self) -> str:
        artist = self.__run_cmd(["playerctl", "--player=spotify", "metadata", "artist"])
        title = self.__run_cmd(["playerctl", "--player=spotify", "metadata", "title"])
        if artist == "" or title == "":
            return ""
        self.__get_cover()
        return f"{artist} - {title}"
