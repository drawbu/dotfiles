{ pkgs, ... }:
{
  imports = [
    ./polkit.nix
    ./xserver.nix
    ./boot.nix
  ];

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };

  programs = {
    # File manager
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  services = {
    # For the file manager
    gvfs.enable = true;
    tumbler.enable = true;

    # Sounds
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    kdeconnect.enable = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      libsForQt5.ark
      libsForQt5.plasma-nm
      modemmanager
      networkmanagerapplet
      physlock
    ];
  };
}
