return {
  'neovim/nvim-lspconfig',

  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },

  {
    'ThePrimeagen/refactoring.nvim',
    config = function()
      require('refactoring').setup {}
    end
  },

  { 'Glench/Vim-Jinja2-Syntax', ft = { 'jinja' } },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup {}
      vim.keymap.set('n', '<leader>x', require('trouble').open, { desc = 'Open all errors' })
    end,
  },

  'sakhnik/nvim-gdb',

  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = {
      keymaps = {
        toggle = '<C-n>',
        go_to_definition = nil,
      },
    },
  },
}
