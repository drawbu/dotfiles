{ pkgs, ... }:
let
  sddmAstronautTheme = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "468a100460d5feaa701c2215c737b55789cba0fc";
    hash = "sha256-L+5xoyjX3/nqjWtMRlHR/QfAXtnICyGzxesSZexZQMA=";
  };
in
{
  environment.systemPackages = with pkgs.libsForQt5.qt5; [
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
  ];
  services.xserver = {
    enable = true;
    layout = "fr";
    libinput.enable = true;

    windowManager = {
      qtile = {
        enable = true;
        extraPackages = python3Packages: with python3Packages; [
          catppuccin
          typing-extensions
        ];
      };
      session = [{
        name = "hyprland";
        start = ''
          Hyprland
        '';
      }];
    };
    desktopManager.gnome.enable = true;
    displayManager = {
      defaultSession = "none+qtile";
      sddm = {
        autoNumlock = true;
        theme = "${sddmAstronautTheme}";
      };
      startx.enable = true;
    };
  };
}
