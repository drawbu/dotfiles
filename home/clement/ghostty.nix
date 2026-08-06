{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    package = pkgs.extra.ghostty;
    settings = {
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      font-family = "Iosevka Mayukai Monolite";

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
