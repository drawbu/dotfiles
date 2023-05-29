{ pkgs, ... }: {
  # Symlink the dotfiles into the home directory

  home.file = {
    ".zshrc".source = ../../.zshrc;
    ".gitconfig".source = ../../.gitconfig;
    "assets".source = ../../assets;

    # dont work. don't know why
    # ".ohmyzsh".source = ../../.ohmyzsh;
    # ".config".source = ../../.config;
  };
}