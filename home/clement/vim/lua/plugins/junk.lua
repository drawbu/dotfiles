return {
  -- Wakatime integration
  'wakatime/vim-wakatime',

  -- Tree of all the changes
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Undo tree' })
    end,
  },

  -- ↓ Editorconfig support
  'gpanders/editorconfig.nvim',

  -- ↓ Epitech plugin
  -- 'drawbu/vim-epitech',

  -- ↓ Highlighing TODO
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
