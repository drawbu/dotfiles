{ ... }:
let
  mailApp = "thunderbird.desktop";
  browser = rec {
    name = "firefox.desktop";
    settings = {
      "x-scheme-handler/http" = name;
      "x-scheme-handler/https" = name;
      "x-scheme-handler/chrome" = name;
      "application/x-extension-htm" = name;
      "application/x-extension-html" = name;
      "application/x-extension-shtml" = name;
      "application/xhtml+xml" = name;
      "application/x-extension-xhtml" = name;
      "application/x-extension-xht" = name;
    };
  };
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/*" = [
          "org.gnome.eog.desktop"
          "feh.desktop"
        ];
        "text/*" = "nvim.desktop";
        "video/*" = "vlc.desktop";
        "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      } // browser.settings;

      associations.added = {
        "text/html" = "firefox.desktop";
        "text/xml" = "firefox.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "x-scheme-handler/jetbrains" = "jetbrains-toolbox.desktop";

        # ↓ Mails
        "application/x-extension-ics" = mailApp;
        "x-scheme-handler/mailto" = mailApp;
        "x-scheme-handler/mid" = mailApp;
        "x-scheme-handler/webcal" = mailApp;
        "x-scheme-handler/webcals" = mailApp;
        "x-scheme-handler/msteams" = "teams-for-linux.desktop";
      } // browser.settings;
    };
  };
}
