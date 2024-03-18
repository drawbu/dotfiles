# My config for Discord
{pkgs, ...}: let
  catppuccin_theme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "df8596640c5486db8177231f4791133ed968b387";
    hash = "sha256-IL3yW2MMy7/0MlwbW2APboZtYEu00Jhtf6WZ+b7t2Hg=";
  };
in {
  home = {
    file = {
      ".config/discocss/custom.css".source = "${catppuccin_theme}/themes/mocha.theme.css";
    };
    packages = with pkgs; [
      discord
      discocss
    ];
  };
}
