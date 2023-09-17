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
    ['<leader>a'] = 'Add to Harpoon',
    ['<leader>l'] = 'Previous Harpoon file',
    ['<leader>h'] = 'Next Harpoon file',
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

