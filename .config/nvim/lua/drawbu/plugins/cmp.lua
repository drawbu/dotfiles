local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup {
    sources = {
        -- Copilot Source
        { name = 'copilot', group_index = 2 },
        -- Other Sources
        { name = 'nvim_lsp', group_index = 2 },
        { name = 'path', group_index = 2 },
        { name = 'luasnip', group_index = 2 },
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            max_width = 50,
            symbol_map = { Copilot = '' }
        })
    }
}

vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', {fg ='#6CC644'})

