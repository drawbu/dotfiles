{pkgs, ...}: let
  theme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "kitty";
    rev = "d7d61716a83cd135344cbb353af9d197c5d7cec1";
    hash = "sha256-mRFa+40fuJCUrR1o4zMi7AlgjRtFmii4fNsQyD8hIjM=";
  };
in {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts.override {fonts = ["ZedMono"];};
      name = "ZedMono Nerd Font";
      size = 12;
    };
    shellIntegration = {
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    settings = {
      # Window
      hide_window_decorations = "no";
      background_opacity = "0.95";
      dynamic_background_opacity = "yes";
      window_padding_width = "0.0";
      remember_window_size = "no";
      initial_window_width = "640";
      initial_window_height = "400";

      # Tabs
      tab_bar_min_tabs = "2";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Remote control
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      enable_audio_bell = "no";
    };
    theme = "Catppuccin-Mocha";

    environment.CURRENT_TERMINAL = "kitty";
  };

  xdg.configFile = {
    "kitty/dark.conf".source = "${theme}/themes/mocha.conf";
    "kitty/light.conf".source = "${theme}/themes/latte.conf";
  };
}
