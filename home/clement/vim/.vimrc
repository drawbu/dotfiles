" my VIM config


" Plugins
call plug#begin()

Plug 'wakatime/vim-wakatime'
Plug 'christoomey/vim-tmux-navigator'
Plug 'drawbu/vim-epitech'

call plug#end()

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
