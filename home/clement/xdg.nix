{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "text/xml" = "firefox.desktop";
      "images/*" = "feh.desktop";
      "video/jpg" = "feh.desktop";
      "video/jpeg" = "feh.desktop";
      "video/png" = "feh.desktop";
      "video/*" = "vlc.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
      "x-scheme-handler/webcal" = "thunderbird.desktop";
      "x-scheme-handler/webcals" = "thunderbird.desktop";
      "application/x-extension-ics" = "thunderbird.desktop";
    };
  };
}
