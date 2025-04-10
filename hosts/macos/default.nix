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

  home-manager.users.clement.home.shellAliases = {
    x86 = "env /usr/bin/arch -x86_64 /bin/zsh --login";
    arm = "env /usr/bin/arch -arm64 /bin/zsh --login";
  };
}
