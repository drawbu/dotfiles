{ ... }:
let
  fn =
    name: schemes:
    builtins.listToAttrs (
      builtins.genList (i: {
        name = builtins.elemAt schemes i;
        value = name;
      }) (builtins.length schemes)
    );
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

        "x-scheme-handler/msteams" = "teams-for-linux.desktop";
        "x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";

        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
      }
      // (fn "org.gnome.font-viewer.desktop" [
        "font/ttf"
        "font/otf"
        "font/woff"
      ])
      // (fn "vlc.desktop" [
        "audio/mp2"
        "audio/flac"
        "audio/x-ms-asx"
        "audio/webm"
        "audio/mp4"
        "audio/x-gsm"
        "audio/aac"
        "audio/x-matroska"
        "audio/x-s3m"
        "audio/vnd.dts.hd"
        "audio/x-aiff"
        "audio/x-xm"
        "audio/x-wavpack"
        "audio/x-tta"
        "audio/vnd.dts"
        "audio/x-mod"
        "audio/x-vorbis+ogg"
        "audio/x-speex"
        "audio/ac3"
        "audio/mpeg"
        "audio/x-ape"
        "audio/vnd.wave"
        "audio/x-mpegurl"
        "audio/x-adpcm"
        "audio/x-scpls"
        "audio/AMR"
        "audio/x-it"
        "audio/AMR-WB"
        "audio/x-ms-wma"
        "audio/x-musepack"
        "audio/ogg"
        "audio/vnd.rn-realaudio"
        "audio/midi"
        "audio/basic"
        "video/*"
        "video/mp4"
        "video/dv"
        "video/webm"
        "video/mp2t"
        "video/x-ms-wmv"
        "video/x-anim"
        "video/x-flv"
        "video/x-theora+ogg"
        "video/mpeg"
        "video/x-matroska"
        "video/vnd.rn-realvideo"
        "video/x-flic"
        "video/x-ogm+ogg"
        "video/vnd.avi"
        "video/3gpp"
        "video/ogg"
        "video/x-nsv"
        "video/vnd.mpegurl"
        "video/quicktime"
        "video/3gpp2"
        "x-content/video-vcd"
        "x-content/video-dvd"
        "x-content/audio-cdda"
        "x-content/video-svcd"
        "x-content/audio-player"
      ])
      // (fn "OrcaSlicer.desktop" [
        "model/3mf"
        "model/stl"
      ])
      // (fn "calibre-gui.desktop" [
        "application/vnd.comicbook-rar"
        "application/x-cb7"
        "application/epub+zip"
        "application/x-mobipocket-ebook"
        "application/vnd.comicbook+zip"
      ])
      // (fn "dev.zed.Zed.desktop" [
        "text/x-c++src"
        "text/x-pascal"
        "text/x-java"
        "text/x-chdr"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-moc"
        "text/x-csrc"
        "text/plain"
      ])
      // (fn "org.gnome.Loupe.desktop" [
        "image/*"
        "image/gif"
        "image/webp"
        "image/vnd.microsoft.icon"
        "image/x-tga"
        "image/x-xpixmap"
        "image/x-portable-bitmap"
        "image/x-portable-anymap"
        "image/tiff"
        "image/vnd.wap.wbmp"
        "image/jxl"
        "image/x-portable-pixmap"
        "image/svg+xml-compressed"
        "image/x-icns"
        "image/bmp"
        "image/x-portable-graymap"
        "image/vnd.zbrush.pcx"
        "image/x-xbitmap"
        "image/svg+xml"
        "image/jpeg"
        "image/png"
      ])
      // (fn "thunderbird.desktop" [
        "application/x-extension-ics"
        "x-scheme-handler/mailto"
        "x-scheme-handler/mid"
        "x-scheme-handler/webcal"
        "x-scheme-handler/webcals"
      ])
      // (fn "firefox.desktop" [
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/chrome"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/xhtml+xml"
        "application/x-extension-xhtml"
        "application/x-extension-xht"
      ]);
    };
  };
}
