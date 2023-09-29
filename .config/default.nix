{ ... }:
{
  home.file = {
    ".config/eww".source = ./eww;
    ".config/neofetch/config.conf".source = ./neofetch/config.conf;
    ".config/nix/nix.conf".source = ./nix/nix.conf;
    ".config/nixpkgs/config.nix".source = ./nixpkgs/config.nix;
    ".config/mimeapps.list".source = ./mimeapps.list;
  };
}
