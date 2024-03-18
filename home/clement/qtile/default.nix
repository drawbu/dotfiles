# Dependencies I use for qtile
{pkgs, ...}: {
  home = {
    file.".config/qtile" = {
      source = ./src;
      onChange = ''
        echo "reload_config()" | ${pkgs.pkgs.qtile-unwrapped}/bin/qtile shell
      '';
    };

    packages = with pkgs; [
      # ↓ Softwares
      rofi # Apps launcher
      networkmanagerapplet # Network tools
      pavucontrol # Audio manager
      rofi-bluetooth # Bluetooth manager

      # ↓ cli
      brightnessctl
      pamixer
      libnotify
      upower
      playerctl
    ];
  };
}
