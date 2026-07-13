vim.diagnostic.config({
    virtual_lines = { current_line = true },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = { diagnostics = { globals = { 'vim' } } }
    },
})

vim.lsp.enable({
    'nixd',
    'lua_ls',
    'clangd',
    'pyright',
    'ts_ls',
    'cssls',
    'svelte',
    'html',
    'gdscript',
    'rust_analyzer',
    'hls',
    'asm_lsp',
    'dockerls',
    'docker_compose_language_service',
    'gopls',
    'cmake',
    'bashls',
    'eslint',
    'emmet_language_server',
    'tailwindcss',
    'templ',
    'htmx',
    'terraformls',
    'uiua',
    'yamlls',
    'zls',
    'typos_lsp',
    'harper_ls',
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.rename)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'g.', vim.lsp.buf.code_action)
vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>k', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
