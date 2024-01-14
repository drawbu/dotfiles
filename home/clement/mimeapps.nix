{ ... }:
let
  mailApp = "thunderbird.desktop";
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/*" = [ "org.gnome.eog.desktop" "feh.desktop" ];
        "text/*" = "nvim.desktop";
        "video/*" = "vlc.desktop";
      };

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
      };
    };
  };
}
