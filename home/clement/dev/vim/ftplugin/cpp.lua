vim.keymap.set('n', '<C-n>', function()
  vim.cmd(':ClangdSwitchSourceHeader')
end, { desc = 'Clangd switch between headers/source', silent = true })
