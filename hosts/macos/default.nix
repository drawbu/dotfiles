{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";

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

  home-manager.users.clementboillot =
    { ... }:
    {
      home.stateVersion = "24.11";
      programs.home-manager.enable = true;

      imports = [
        ../../home/clement/vim
        ../../home/clement/shell
        ../../home/clement/git.nix
        ../../home/clement/dev
        ../../home/clement/tmux.nix
        ../../home/clement/btop.nix
        ../../home/clement/gh.nix
      ];
    };
}
