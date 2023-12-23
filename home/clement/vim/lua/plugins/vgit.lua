return {{
  'tanvirtin/vgit.nvim',
  version = 'v0.2.1',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local vgit = require('vgit')

    vgit.setup({
      keymaps = {
        ['n <leader>gf'] = function() vgit.buffer_diff_preview() end,
        ['n <leader>gh'] = function() vgit.buffer_history_preview() end,
        ['n <leader>gu'] = function() vgit.buffer_reset() end,
      }
    })
  end,
}}

