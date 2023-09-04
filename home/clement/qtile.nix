# Dependencies I use for qtile
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # ↓ Softwares
    qtile
    picom # Compositor
    betterlockscreen # Lock screen
    dunst # Notifications
    rofi # Apps launcher
    networkmanagerapplet # Network tools

    # ↓ cli
    brightnessctl
    pamixer
    libnotify
    upower
    playerctl

    # ↓ Fonts
    jetbrains-mono
    nerdfonts
  ];
}
