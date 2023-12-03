return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = false,
    config = function()
      require('copilot').setup({
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = false,
        },
        filetypes = {
          yaml = true,
          markdown = true,
        },
      })
    end,
  },

  {
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
    config = function ()
      require('copilot_cmp').setup()
    end
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      -- LuaSnip
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Icons
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')

      -- Buffer completion
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'copilot' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format({
              mode = 'symbol_text',
              max_width = 50,
              symbol_map = { Copilot = '' },
            })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    (' .. (strings[2] or '') .. ')'

            return kind
          end
        },
        window = {
          completion = {
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -3,
            side_padding = 0,
          },
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
      })

      -- Autocomplete search
      cmp.setup.cmdline({'/', '?'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'buffer' }}
      })

      -- Autocomplete command
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
        {{ name = 'path' }},
        {{
          name = 'cmdline',
          option = { ignore_cmds = { 'Man', '!' } }
        }}
        )
      })

      -- Highlighting
      vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#282C34', fg = 'NONE' })
      vim.api.nvim_set_hl(0, 'Pmenu', { fg = '#C5CDD9', bg = '#22252A' })

      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { fg = '#7E8294', bg = 'NONE', strikethrough = true })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#82AAFF', bg = 'NONE', bold = true })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = '#82AAFF', bg = 'NONE', bold = true })
      vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = '#C792EA', bg = 'NONE', italic = true })

      vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = '#EED8DA', bg = '#B5585F' })
      vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { fg = '#EED8DA', bg = '#B5585F' })
      vim.api.nvim_set_hl(0, 'CmpItemKindEvent', { fg = '#EED8DA', bg = '#B5585F' })

      vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = '#C3E88D', bg = '#9FBD73' })
      vim.api.nvim_set_hl(0, 'CmpItemKindEnum', { fg = '#C3E88D', bg = '#9FBD73' })
      vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = '#C3E88D', bg = '#9FBD73' })

      vim.api.nvim_set_hl(0, 'CmpItemKindConstant', { fg = '#FFE082', bg = '#D4BB6C' })
      vim.api.nvim_set_hl(0, 'CmpItemKindConstructor', { fg = '#FFE082', bg = '#D4BB6C' })
      vim.api.nvim_set_hl(0, 'CmpItemKindReference', { fg = '#FFE082', bg = '#D4BB6C' })

      vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = '#EADFF0', bg = '#A377BF' })
      vim.api.nvim_set_hl(0, 'CmpItemKindStruct', { fg = '#EADFF0', bg = '#A377BF' })
      vim.api.nvim_set_hl(0, 'CmpItemKindClass', { fg = '#EADFF0', bg = '#A377BF' })
      vim.api.nvim_set_hl(0, 'CmpItemKindModule', { fg = '#EADFF0', bg = '#A377BF' })
      vim.api.nvim_set_hl(0, 'CmpItemKindOperator', { fg = '#EADFF0', bg = '#A377BF' })
      vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#EAFFF0', bg ='#6CC644' })

      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = '#C5CDD9', bg = '#7E8294' })
      vim.api.nvim_set_hl(0, 'CmpItemKindFile', { fg = '#C5CDD9', bg = '#7E8294' })

      vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { fg = '#F5EBD9', bg = '#D4A959' })
      vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = '#F5EBD9', bg = '#D4A959' })
      vim.api.nvim_set_hl(0, 'CmpItemKindFolder', { fg = '#F5EBD9', bg = '#D4A959' })

      vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = '#DDE5F5', bg = '#6C8ED4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindValue', { fg = '#DDE5F5', bg = '#6C8ED4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindEnumMember', { fg = '#DDE5F5', bg = '#6C8ED4' })

      vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { fg = '#D8EEEB', bg = '#58B5A8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindColor', { fg = '#D8EEEB', bg = '#58B5A8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindTypeParameter', { fg = '#D8EEEB', bg = '#58B5A8' })
    end,
  },

}
