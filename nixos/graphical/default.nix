{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./polkit.nix
    ./xdg.nix
    ./xserver.nix
  ];

  config = lib.mkIf config.mod.profiles.desktop.enable {
    console.useXkbConfig = true;

    hardware = {
      bluetooth.enable = true;

      uinput.enable = true;

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
      kdeconnect.enable = true;
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
    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          .helium-wrapped
        '';
        mode = "0755";
      };
    };
    environment.sessionVariables = {
      OP_BIOMETRIC_UNLOCK_ENABLED = "true";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      XCURSOR_SIZE = 16;
    };

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

    # Without a managed slice oomd runs but supervises nothing.
    systemd.oomd = {
      enableRootSlice = true;
      enableUserSlices = true;
      settings.OOM = {
        DefaultMemoryPressureDurationSec = "10s";
      };
    };
  };
}
