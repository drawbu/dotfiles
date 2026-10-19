{ pkgs, ... }:
{
  imports = [ ./nix.nix ];

  system.copySystemConfiguration = false;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    command-not-found.enable = false;
    zsh.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
  ];

  environment = {
    enableAllTerminfo = true;
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      vim
      wget
      extra.nix-alien
    ];
    pathsToLink = [ "/share/nix-direnv" ];
  };

  security.sudo.extraConfig = ''
    Defaults insults
  '';
}
