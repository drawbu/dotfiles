{pkgs, ...}: {
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

  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
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
    blueman.enable = true;

    # Sounds
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    printing.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    kdeconnect.enable = true;
  };

  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      libsForQt5.ark
      libsForQt5.plasma-nm
      modemmanager
      networkmanagerapplet
      physlock
    ];
  };

  virtualisation.waydroid.enable = true;
}
