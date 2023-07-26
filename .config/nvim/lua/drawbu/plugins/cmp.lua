local cmp = require('cmp')
local lspkind = require('lspkind')

-- Buffer completion
cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = {
        { name = 'copilot' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            max_width = 50,
            symbol_map = { Copilot = '' }
        })
    },
})

-- Autocomplete search
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Autocomplete command
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})

vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', {fg ='#6CC644'})

