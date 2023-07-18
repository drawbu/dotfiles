local lsp = require('lsp-zero').preset({})

-- Nix
require('lspconfig').nil_ls.setup({})
-- Lua
require('lspconfig').lua_ls.setup({})
-- C
require('lspconfig').clangd.setup({})
-- Python
require('lspconfig').pyright.setup({})
-- TypeScript
require('lspconfig').tsserver.setup({})
-- CSS
require('lspconfig').cssls.setup({})
-- Svelte
require('lspconfig').svelte.setup({})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

