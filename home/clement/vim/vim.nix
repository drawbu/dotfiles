{pkgs, ...}: {
  home = {
    file.".vimrc".text =
      /*vim*/ ''
        source ${pkgs.vimPlugins.vim-plug}/plug.vim

        call plug#begin()

        Plug 'wakatime/vim-wakatime'
        Plug 'drawbu/vim-epitech'

        call plug#end()

        syntax off
        colorscheme pablo
        hi Normal guibg=NONE ctermbg=NONE

        highlight RedundantSpaces ctermbg=red guibg=red
        match RedundantSpaces /\s\+$/

        " Infinite undo
        if has('persistent_undo')
            set undodir=$HOME/.vim/undo
            set undofile
        endif
      ''
      + builtins.readFile ./.vimrc;

    packages = with pkgs; [vim];
  };
}
