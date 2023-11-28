local lsp_zero = require('lsp-zero').preset({})
local lsp = require('lspconfig')
local vim = vim
local configs = require('lspconfig.configs')

-- ↓ Nix
lsp.nil_ls.setup({})

-- ↓ Lua
lsp.lua_ls.setup({})

-- ↓ C
lsp.clangd.setup({
  cmd = {
    'clangd',
    '--background-index',
    '--offset-encoding=utf-16',
    '--clang-tidy',
    '--cross-file-rename',
  },
})

-- ↓ Python
lsp.pyright.setup({})

-- ↓ TypeScript
lsp.tsserver.setup({})

-- ↓ CSS
lsp.cssls.setup({})

-- ↓ Svelte
lsp.svelte.setup({})

-- ↓ HTML
lsp.html.setup({})

-- ↓ Godot
lsp.gdscript.setup({})

-- ↓ Epitech C Style Checker
if not configs.ecsls then
  configs.ecsls = {
    default_config = {
      root_dir = lsp.util.root_pattern('.git', 'Makefile'),
      cmd = { 'ecsls_run' },
      autostart = true,
      name = 'ecsls',
      filetypes = { 'c', 'cpp', 'make' },
    },
  }
end
lsp.ecsls.setup({})

lsp_zero.on_attach(function(_, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
    lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.setup()

