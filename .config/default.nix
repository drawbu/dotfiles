{ ... }:
{
  home.file = {
    ".config/btop/btop.conf".source = ./btop/btop.conf;
    ".config/btop/themes/onedark.theme".source = ./btop/themes/onedark.theme;
    ".config/dunst/dunstrc".source = ./dunst/dunstrc;
    ".config/eww".source = ./eww;
    ".config/gh/config.yml".source = ./gh/config.yml;
    ".config/htop/htoprc".source = ./htop/htoprc;
    ".config/kitty/kitty.conf".source = ./kitty/kitty.conf;
    ".config/neofetch/config.conf".source = ./neofetch/config.conf;
    ".config/nix/nix.conf".source = ./nix/nix.conf;
    ".config/nixpkgs/config.nix".source = ./nixpkgs/config.nix;
    ".config/qtile".source = ./qtile;
    ".config/tmux/tmux.conf".source = ./tmux/tmux.conf;
    ".config/mimeapps.list".source = ./mimeapps.list;
  };
}
