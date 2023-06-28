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
    ['<leader>z'] = 'Zen mode',
    ['<leader>u'] = 'Undo tree',
    ['<leader>d'] = 'Delete to void',
    ['<leader> '] = 'Open a terminal',
    ['<leader>:'] = 'Comment the line',
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

