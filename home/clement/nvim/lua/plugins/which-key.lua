return {{
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require('which-key')

    wk.register({
      ['<leader>p'] = {
        name = '+project',
        f = 'Find File',
        v = 'Open directory',
        s = 'Grep search',
      },
    })

    wk.register({
      ['<leader>u'] = 'Undo tree',
      ['<leader> '] = 'Open a terminal',
      ['<leader>x'] = 'Open all errors',
    })

    wk.register({
      ['<leader>g'] = {
        name = '+git',
        f = 'Diff preview',
        h = 'File history',
        u = 'Reset file',
        l = 'Open lazygit',
      },
    })
  end,
}}
