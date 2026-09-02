{ pkgs, ... }:
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    rev = "91e071bf9b9b2b8ae176a5581fcb61c789c55cab";
    hash = "sha256-F05ohJp7c9Pdnjq8+srfhAt1ogHjjBz50k1ftHOHGVg=";
  };
in
{
  xdg.configFile."helix/themes" = {
    source = "${catppuccin}/themes";
    recursive = true;
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        rulers = [
          80
          120
        ];

        file-picker.hidden = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
