{ pkgs, ... }:
let
  bashWakatime = pkgs.fetchFromGitHub {
    owner = "gjsheep";
    repo = "bash-wakatime";
    rev = "c97292398936393c3f985f4924a3c234793ca3b8";
    sha256 = "sha256-Heq/VxfCqFhnYxAm2ejymANdPmZ5uNixuZiuC/53VQE=";
  };
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      source ${bashWakatime}/bash-wakatime.sh
      source ~/assets/.profile
    '';
  };
}
