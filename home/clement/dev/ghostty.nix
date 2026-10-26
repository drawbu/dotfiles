{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = lib.mkDefault config.mod.profiles.desktop.enable;
    systemd.enable = pkgs.stdenv.isLinux;
    package = if pkgs.stdenv.isLinux then pkgs.extra.ghostty else null;
    settings = {
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      font-family = "Ioskeley Mono";

      shell-integration-features = "ssh-env,ssh-terminfo";

      background-opacity = 0.95;

      cursor-click-to-move = true;
      mouse-hide-while-typing = true;

      window-decoration = false;
      window-theme = "ghostty";

      auto-update = "check";

      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "no-bell,notify";
      notify-on-command-finish-after = "30s";

      quit-after-last-window-closed = false;
    };
  };
}
