return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    require 'nvim-treesitter.configs'.setup {
      auto_install = false,
      ensure_installed = {},
      indent = {
        enable = true
      },
      highlight = {
        enable = true,
      },
    }

    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
}
