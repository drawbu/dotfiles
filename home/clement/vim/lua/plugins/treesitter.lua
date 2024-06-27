return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    version = 'v0.9.2',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
  {
    "jmbuhr/otter.nvim", -- Embeded code lsp
    dependencies = {
      'hrsh7th/nvim-cmp', -- optional, for completion
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter'
    },
    after = "nvim-treesitter",
    config = function()
      require('otter').activate({ "python", "lua", "bash", "conf", "ini", "vim", "sh", "md", "json" }, true, true)
    end,
  },
}
