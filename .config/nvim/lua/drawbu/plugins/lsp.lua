local lsp = require('lsp-zero').preset({})

-- LSP servers
require('lspconfig').nil_ls.setup{}
require('lspconfig').lua_ls.setup{}
require('lspconfig').clangd.setup{}

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

