{ pkgs, ... }:
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fuzzel";
    rev = "0af0e26901b60ada4b20522df739f032797b07c3";
    hash = "sha256-XpItMGsYq4XvLT+7OJ9YRILfd/9RG1GMuO6J4hSGepg=";
  };
in
{
  home.packages = with pkgs; [ fuzzel ];
  xdg.configFile."fuzzel/fuzzel.ini".source = "${catppuccin}/themes/catppuccin-mocha/green.ini";
}
