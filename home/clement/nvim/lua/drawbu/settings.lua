local vim = vim

-- ↓ Lines numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- ↓ Line at 80 chars
vim.wo.colorcolumn = '80'
vim.opt.cursorline = true

-- ↓ Indent
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.python_indent = {
    open_paren = 'shiftwidth()',
    closed_paren_align_last_line = true,
}

-- ↓ All my homies hate swapfile
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true
vim.opt.swapfile = false

-- ↓ Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- ↓ Curor never touching borders
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99 -- Minimum number of screen line below and above the cursor
vim.opt.foldenable = true
vim.opt.scrolloff = 99

vim.cmd('filetype plugin on')

