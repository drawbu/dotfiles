vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.lsp.enable('nixd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
vim.lsp.enable('ts_ls')
vim.lsp.enable('cssls')
vim.lsp.enable('svelte')
vim.lsp.enable('html')
vim.lsp.enable('gdscript')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('hls')
vim.lsp.enable('asm_lsp')
vim.lsp.enable('dockerls')
vim.lsp.enable('docker_compose_language_service')
vim.lsp.enable('gopls')
vim.lsp.enable('cmake')
vim.lsp.enable('bashls')
vim.lsp.enable('eslint')
vim.lsp.enable('emmet_language_server')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('templ')
vim.lsp.enable('htmx')
vim.lsp.enable('terraformls')
vim.lsp.enable('uiua')
vim.lsp.enable('yamlls')
vim.lsp.enable('zls')

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.rename)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action)
vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>k', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
