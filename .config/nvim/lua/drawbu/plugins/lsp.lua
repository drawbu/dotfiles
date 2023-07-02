local lsp = require('lsp-zero').preset({})

-- Nix
require('lspconfig').nil_ls.setup({})
-- Lua
require('lspconfig').lua_ls.setup({})
-- C
require('lspconfig').clangd.setup({})
-- Python
require('lspconfig').pyright.setup({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

