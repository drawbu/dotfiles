{ pkgs, ... }:
{
  home-manager.users.clement = import ../home/clement;
  users.users.clement = {
    isNormalUser = true;
    initialPassword = "hello";
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "libvirtd" "wheel" ];
    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEIMRXQMnaP08FgRGXEpgX9oDADom5h+xjAnEgLNCXF clement2104.boillot@gmail.com''
    ];
    createHome = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    optimise.automatic = true;
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        nix-direnv = super.nix-direnv.override {
          enableFlakes = true;
        };
      })
    ];
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    command-not-found.enable = true;
    dconf.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    zsh.enable = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  networking.networkmanager.enable = true;

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      git
      btop
      tree
      vim
      wget
    ];
  };

  system = {
    copySystemConfiguration = false;
    stateVersion = "23.05";
  };
}
