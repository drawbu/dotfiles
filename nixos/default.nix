{
  pkgs,
  nix-alien,
  ...
}: {
  system.copySystemConfiguration = false;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };
    optimise.automatic = true;
  };

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

    nix-ld = {
      enable = true;
      libraries = with pkgs; [];
    };
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  virtualisation = {
    libvirtd.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  networking.networkmanager.enable = true;
  zramSwap.enable = true;

  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      git
      btop
      tree
      vim
      wget
      virt-manager
      nix-alien
      podman-compose
    ];
    pathsToLink = ["/share/nix-direnv"];
    etc.issue.text = builtins.readFile ./issue.txt;
  };
}
