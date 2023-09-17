local vim = vim

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Strait to the void register 
vim.keymap.set('x', '<leader>p', [['_dP]])
vim.keymap.set({'n', 'v'}, '<leader>d', [['_d]])

-- Center for vertical movement
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

