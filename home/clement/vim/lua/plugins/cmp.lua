return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'tamago324/cmp-zsh',
      'hrsh7th/cmp-nvim-lua',
      'SergioRibera/cmp-dotenv',

      -- LuaSnip
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',

      -- Icons
      'onsails/lspkind.nvim',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load() -- lspkind
      local cmp = require('cmp')

      -- Buffer completion
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'path' },
          { name = 'supermaven' },
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'otter' },
          { name = 'dotenv' },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format({
              mode = 'symbol_text',
              max_width = 50,
              symbol_map = { nvim_lua = ' ', dotenv = '', Supermaven = "" },
            })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    (' .. (strings[2] or '') .. ')'

            return kind
          end
        },
        window = {
          completion = {
            -- winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            -- ? broken

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
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
      })

      -- Autocomplete command
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = 'path' } },
          { { name = 'cmdline' } },
          { { name = 'zsh' } }
        )
      })

      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
    end,
  },
  {
    -- "jmbuhr/otter.nvim", -- Embeded code lsp
    -- version = '*',
    -- dependencies = {
    --   'neovim/nvim-lspconfig',
    --   'nvim-treesitter/nvim-treesitter'
    -- },
    -- config = function()
    --   vim.keymap.set('n', '<C-o>', require('otter').activate, { desc = 'Trigger otter', silent = true })
    -- end,
  },
}
