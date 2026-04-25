{ pkgs, ... }:
{
  imports = [
    ./polkit.nix
    ./xserver.nix
    ./boot.nix
    ./xdg.nix
  ];

  console.useXkbConfig = true;

  hardware = {
    bluetooth.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  services = {
    pulseaudio.enable = false;
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
      raopOpenFirewall = true;
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
      openFirewall = true;
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
    gamemode = {
      enable = true;
      settings.custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
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

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "clement" ];
  };
  environment.sessionVariables = {
    OP_BIOMETRIC_UNLOCK_ENABLED = "true";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    XCURSOR_SIZE = 16;
  };

  # Propagate the above into the systemd --user manager so units (e.g. vicinae)
  # and apps they spawn inherit them. environment.sessionVariables alone only
  # reaches login shells. XDG_SESSION_TYPE=wayland is required so Chromium's
  # --ozone-platform-hint=auto resolves to wayland (else it falls back to x11).
  environment.etc."environment.d/10-session.conf".text = ''
    NIXOS_OZONE_WL=1
    ELECTRON_OZONE_PLATFORM_HINT=wayland
    XCURSOR_SIZE=16
    XDG_SESSION_TYPE=wayland
  '';

  networking = {
    timeServers = [
      "0.fr.pool.ntp.org"
      "1.fr.pool.ntp.org"
      "2.fr.pool.ntp.org"
      "3.fr.pool.ntp.org"
    ];
    stevenblack.enable = true;
  };

  services.xserver.xkb.extraLayouts.us_qwerty-fr = {
    description = pkgs.qwerty-fr.meta.description;
    languages = [
      "eng"
      "fra"
    ];
    symbolsFile = "${pkgs.qwerty-fr}/share/X11/xkb/symbols/us_qwerty-fr";
  };

  networking.nameservers = [ "1.1.1.1" ];

  systemd.oomd = {
    enable = true;
    settings.OOM = {
      DefaultMemoryPressureDurationSec = "10s";
    };
  };
}
