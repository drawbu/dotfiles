{ pkgs, ... }:
{
  home = {
    file.".vimrc".text = builtins.readFile ./common.vim + ''
      syntax off
      colorscheme pablo
      hi Normal guibg=NONE ctermbg=NONE

      highlight RedundantSpaces ctermbg=red guibg=red
      match RedundantSpaces /\s\+$/

      " Open parent directory
      nnoremap - :Ex<CR>

      nnoremap <leader>l :bnext<cr>
      nnoremap <leader>h :bprevious<cr>

      " Infinite undo
      if has('persistent_undo')
          set undodir=$HOME/.vim/undo
          set undofile
      endif
    '';

    packages = with pkgs; [ vim ];
  };
}
