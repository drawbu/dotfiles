{ pkgs, ... }:
{
  home.packages = [ pkgs.ghostty ];
  xdg.configFile = {
    "ghostty/config".text = ''
      theme = dark:catppuccin-mocha,light:catppuccin-latte
      font-family = Iosevka Mayukai Monolite

      background-opacity = 0.95
      window-height = 20
      window-width = 96

      cursor-click-to-move = true
      mouse-hide-while-typing = true

      window-decoration = false
      window-theme = ghostty

      auto-update = check
    '';
  };
}
