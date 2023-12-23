-- ↓ Indent
vim.g.python_indent = {
    open_paren = 'shiftwidth()',
    closed_paren_align_last_line = true,
}

-- ↓ Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- ↓ Curor never touching borders
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99 -- Minimum number of screen line below and above the cursor
vim.opt.foldenable = true
vim.opt.scrolloff = 99
