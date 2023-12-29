return {
  'folke/which-key.nvim',
  priority = 1000,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require('which-key')

    wk.register({
      ['<leader>g'] = { name = '+git' },
      ['<leader>d'] = { name = '+gdb' },
      ['<leader>p'] = { name = '+project', p = 'Open directory' },
    })
  end,
}
