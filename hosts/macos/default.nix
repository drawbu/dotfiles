{ lib, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "clementboillot";
  users.users.clementboillot = {
    name = "clementboillot";
    home = "/Users/clementboillot";
  };

  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
  };

  system.defaults.finder.ShowPathbar = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = false;

  home-manager.users.clementboillot =
    { pkgs, ... }:
    {
      imports = [
        ../../home/clement
        ../../home/clement/macos.nix
      ];
      home = {
        username = lib.mkForce "clementboillot";
        stateVersion = "24.11";
        packages = with pkgs; [
          gnugrep
          gnused
        ];
      };
    };
}
