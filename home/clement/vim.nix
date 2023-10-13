{ pkgs, ... }:
let
  vimEpitech = pkgs.fetchFromGitHub {
    owner = "drawbu";
    repo = "vim-epitech";
    rev = "9d534c65ef4efa7830bad055268219b2f49fe88e";
    hash = "sha256-tqudZZNO3oCfxeWmrNzY6Y9F+VrqU8RatlC/Qcndfzk=";
  };
in
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      vim-wakatime
      vimEpitech
    ];
    extraConfig = ''
      let mapleader = " "

      " File format
      set fileformat=unix

      " Lines numbers
      set number
      set relativenumber

      " 80 columns
      set colorcolumn=80
      set cursorline

      " Indents
      set smartindent
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set expandtab

      " Infinite undo
      if has('persistent_undo')
        set undodir=$HOME/.vim/undo
        set undofile
      endif

      " Swapfiles
      set noswapfile

      " Colors
      syntax off
      colorscheme pablo
      hi Normal guibg=NONE ctermbg=NONE

      " Hightlight spaces
      highlight RedundantSpaces ctermbg=red guibg=red
      match RedundantSpaces /\s\+$/

      " Switch between buffers
      map <leader>l :bnext<cr>
      map <leader>h :bprevious<cr>
      map <leader>x :bdelete<cr>

      " Smooth scroll
      map <C-u> <C-u>zz<cr>
      map <C-d> <C-d>zz<cr>
    '';
  };
}
