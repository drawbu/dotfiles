return {
  -- Wakatime integration
  'wakatime/vim-wakatime',

  -- Tree of all the changes
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },

  -- ↓ Editorconfig support
  'gpanders/editorconfig.nvim',

  -- ↓ See all the errors
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup {}
      vim.keymap.set('n', '<leader>x', function() require('trouble').open() end)
    end,
  },

  -- ↓ Easy navigation between neovim & tmux
  'christoomey/vim-tmux-navigator',

  -- ↓ Jinja support
  { 'Glench/Vim-Jinja2-Syntax', ft = { 'jinja' } },

  -- ↓ Epitech plugin
  'drawbu/vim-epitech',

  -- ↓ Code action lightbulb
  {
    'kosayoda/nvim-lightbulb',
    config = function ()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },

  -- ↓ Highlighing TODO
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- ↓ Refactor utils
  {
    'ThePrimeagen/refactoring.nvim',
    config = function ()
      require('refactoring').setup({})
    end
  },
}
