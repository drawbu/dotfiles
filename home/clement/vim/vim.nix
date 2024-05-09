{pkgs, ...}: {
  home = {
    file.".vimrc".text =
      ''
        source ${pkgs.vimPlugins.vim-plug}/plug.vim

        call plug#begin()

        Plug 'wakatime/vim-wakatime'
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'drawbu/vim-epitech'

        call plug#end()

        syntax off
        colorscheme pablo
        hi Normal guibg=NONE ctermbg=NONE

        highlight RedundantSpaces ctermbg=red guibg=red
        match RedundantSpaces /\s\+$/

        " Infinite undo
        if has('persistent_undo')
            set undodir=$HOME/.nvim/undo
            set undofile
        endif
      ''
      + builtins.readFile ./.vimrc;

    packages = with pkgs; [vim];
  };
}
