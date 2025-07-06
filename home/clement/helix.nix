{ pkgs, ... }:
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    rev = "a388c963213fbf2be0f1e793353e2b81f8e2068c";
    hash = "sha256-MS1oDn+nMlPL5EJb/lXBVXMzku7vmuMWneMAXdTB1nU=";
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
        rulers = [80 120];

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
