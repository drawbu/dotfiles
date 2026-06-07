{ ... }:
{
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = "dark:Catppuccin Mocha,light:Catppuccin Latte";
      font-family = "Iosevka Mayukai Monolite";

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
