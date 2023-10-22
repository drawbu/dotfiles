# Dependencies I use for qtile
{ pkgs, ... }: {
  home = {
    file.".config/qtile".source = ./src;

    packages = with pkgs; [
      # ↓ Softwares
      qtile
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
