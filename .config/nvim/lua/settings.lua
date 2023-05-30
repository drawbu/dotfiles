require('vgit').setup()
require('lualine').setup()
require'nvim-treesitter.configs'.setup {
  -- Always installed parsers
  ensure_installed = { "c", "lua", "vim", "nix" },
  
  -- Enable highlighting
  highlight = {
    enable = true
  }
}

vim.opt.number = true
vim.opt.relativenumber = true

vim.cmd('colorscheme onedark')

vim.wo.colorcolumn = '80'
vim.opt.cursorline = true
