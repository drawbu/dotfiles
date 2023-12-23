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

" All my homies hate swapfile
set noswapfile

" Custom settings
filetype plugin on

" Colors
syntax off
colorscheme pablo
hi Normal guibg=NONE ctermbg=NONE

" Hightlight spaces
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/

" Switch between buffers
nnoremap <leader>pv :Ex<CR>
nnoremap <leader>l :bnext<cr>
nnoremap <leader>h :bprevious<cr>

" Smooth scroll
map <C-u> <C-u>zz<cr>
map <C-d> <C-d>zz<cr>
map n nzz
map N Nzz
