{ pkgs, ... }:
{
  home = {
    file.".vimrc".text = ''
      source ${pkgs.vimPlugins.vim-plug}/plug.vim
    '' + builtins.readFile ./.vimrc;

    packages = with pkgs; [
      vim
    ];
  };
}
