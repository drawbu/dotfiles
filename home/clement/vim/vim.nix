{ pkgs, ... }:
{
  home = {
    file.".vimrc".text = ''
      source ${pkgs.vimPlugins.vim-plug}/plug.vim

      call plug#begin()

      Plug 'wakatime/vim-wakatime'
      Plug 'christoomey/vim-tmux-navigator'
      Plug 'drawbu/vim-epitech'

      call plug#end()

    '' + builtins.readFile ./.vimrc;

    packages = with pkgs; [
      vim
    ];
  };
}
