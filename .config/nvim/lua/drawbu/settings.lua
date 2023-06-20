require('lualine').setup()

vim.opt.number = true
vim.opt.relativenumber = true

vim.wo.colorcolumn = '80'
vim.opt.cursorline = true

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.clipboard = "unnamedplus"

