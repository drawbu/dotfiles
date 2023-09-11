{ ... }:
{
  home.file = {
    ".config/btop/btop.conf".source = ./btop/btop.conf;
    ".config/btop/themes/onedark.theme".source = ./btop/themes/onedark.theme;
    ".config/dunst/dunstrc".source = ./dunst/dunstrc;
    ".config/eww".source = ./eww;
    ".config/flameshot/flameshot.ini".source = ./flameshot/flameshot.ini;
    ".config/gh/config.yml".source = ./gh/config.yml;
    ".config/htop/htoprc".source = ./htop/htoprc;
    ".config/kitty/kitty.conf".source = ./kitty/kitty.conf;
    ".config/neofetch/config.conf".source = ./neofetch/config.conf;
    ".config/nix/nix.conf".source = ./nix/nix.conf;
    ".config/nixpkgs/config.nix".source = ./nixpkgs/config.nix;
    ".config/nvim/lua".source = ./nvim/lua;
    ".config/nvim/ftplugin".source = ./nvim/ftplugin;
    ".config/picom/picom.conf".source = ./picom/picom.conf;
    ".config/qtile".source = ./qtile;
    ".config/rofi/config.rasi".source = ./rofi/config.rasi;
    ".config/tmux/tmux.conf".source = ./tmux/tmux.conf;
    "mimeapps.list".source = ./mimeapps.list;
  };
}
