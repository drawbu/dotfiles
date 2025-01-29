return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
    },
    config = function()
      local lsp_zero = require('lsp-zero').preset({})
      local lsp = require('lspconfig')
      local configs = require('lspconfig.configs')

      -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
      -- https://github.com/hrsh7th/cmp-nvim-lsp/issues/42#issuecomment-1283825572
      local caps = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        -- File watching is disabled by default for neovim.
        -- See: https://github.com/neovim/neovim/pull/22405
        { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
      );

      lsp.nixd.setup {}
      lsp.lua_ls.setup {}
      lsp.clangd.setup {
        capabilities = caps,
        cmd = {
          'clangd',
          '--background-index',
          '--offset-encoding=utf-16',
          '--clang-tidy',
          '--cross-file-rename',
        },
      }
      lsp.pyright.setup {}
      lsp.ts_ls.setup {}
      lsp.cssls.setup {}
      lsp.svelte.setup {}
      lsp.html.setup {}
      lsp.gdscript.setup {}
      lsp.rust_analyzer.setup {}
      lsp.hls.setup {}
      lsp.asm_lsp.setup {}
      lsp.dockerls.setup {}
      lsp.docker_compose_language_service.setup {}
      lsp.gopls.setup {}
      lsp.cmake.setup {}
      lsp.bashls.setup {}
      lsp.eslint.setup {}
      lsp.emmet_language_server.setup {}
      lsp.tailwindcss.setup {
        root_dir = function(fname)
          local root_pattern = require("lspconfig").util.root_pattern(
            "tailwind.config.cjs",
            "tailwind.config.js",
            "postcss.config.js"
          )
          return root_pattern(fname)
        end,
      }
      lsp.templ.setup {}
      lsp.htmx.setup {}
      lsp.terraformls.setup {}
      lsp.yamlls.setup {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
        }
      }
      lsp.zls.setup {}

      -- ↓ Epitech C Style Checker
      -- if not configs.ecsls then
      --   configs.ecsls = {
      --     default_config = {
      --       root_dir = lsp.util.root_pattern('.git', 'Makefile'),
      --       cmd = { 'ecsls_run' },
      --       autostart = true,
      --       name = 'ecsls',
      --       filetypes = { 'c', 'cpp', 'make' },
      --     },
      --   }
      -- end
      -- lsp.ecsls.setup {}

      lsp_zero.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
        vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>k', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
          opts)
        vim.keymap.set('n', 'gf', vim.lsp.buf.format, opts)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      lsp_zero.setup()
    end,
  },

  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },

  {
    'ThePrimeagen/refactoring.nvim',
    config = function()
      require('refactoring').setup {}
    end
  },

  { 'Glench/Vim-Jinja2-Syntax', ft = { 'jinja' } },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup {}
      vim.keymap.set('n', '<leader>x', require('trouble').open, { desc = 'Open all errors' })
    end,
  },

  'sakhnik/nvim-gdb',

  'tjdevries/templ.nvim',

  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = {
      keymaps = {
        toggle = '<C-n>',
        go_to_definition = nil,
      },
    },
  },
}
