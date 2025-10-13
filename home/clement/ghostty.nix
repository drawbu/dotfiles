{ pkgs, ... }:
{
  home.packages = [ pkgs.extra.ghostty ];
  xdg.configFile = {
    "ghostty/config".text = ''
      theme = dark:Catppuccin Mocha,light:Catppuccin Latte
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
