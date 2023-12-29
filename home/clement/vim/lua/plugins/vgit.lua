return {
  'tanvirtin/vgit.nvim',
  version = 'v0.2.1',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local vgit = require('vgit')

    vgit.setup({})

    vim.keymap.set('n', '<leader>gf', vgit.buffer_diff_preview, { desc = 'Diff preview' })
    vim.keymap.set('n', '<leader>gh', vgit.buffer_history_preview, { desc = 'File history' })
    vim.keymap.set('n', '<leader>gu', vgit.buffer_reset, { desc = 'Restore file' })
  end,
}
