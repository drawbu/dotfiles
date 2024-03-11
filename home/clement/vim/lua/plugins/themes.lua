return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme catppuccin')
    end
  },

  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = true,
  },

  {
    'xiyaowong/transparent.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('TransparentEnable')
    end
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  }
}
