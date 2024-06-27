{pkgs, ...}: let
  py = pkgs.python3.withPackages (
    p:
      [pkgs.qtile-unwrapped]
      ++ (with p; [
        catppuccin
        typing-extensions
      ])
  );
in {
  home = {
    file.".config/qtile" = {
      source = ./src;
      onChange = /*bash*/ ''
        pkill -f qtile -SIGUSR1
      '';
    };

    packages = with pkgs; [
      (pkgs.writeShellScriptBin "qtile" ''
        ${py}/bin/qtile "$@"
      '')

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
