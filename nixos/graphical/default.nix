{ pkgs, ... }:
{
  imports = [
    ./polkit.nix
    ./xserver.nix
    ./boot.nix
    ./xdg.nix
  ];

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  services = {
    upower.enable = true;
    # For the file manager
    gvfs.enable = true;
    tumbler.enable = true;
    blueman.enable = true;

    resolved.enable = true; # wireguard

    # Sounds
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        canon-cups-ufr2
        cups-filters
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    libinput.enable = true;
    flatpak.enable = true;
  };

  programs = {
    xwayland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    kdeconnect.enable = true;
    gamemode.enable = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      modemmanager
      networkmanagerapplet
    ];
  };

  # virtualisation.waydroid.enable = true;

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
    fi
  '';

  fonts.enableDefaultPackages = true;
}
