return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
    },
    config = function()
      local lsp_zero = require('lsp-zero').preset({})
      local lsp = require('lspconfig')
      local configs = require('lspconfig.configs')

      lsp.nil_ls.setup({})
      lsp.lua_ls.setup({})
      lsp.clangd.setup({
        cmd = {
          'clangd',
          '--background-index',
          '--offset-encoding=utf-16',
          '--clang-tidy',
          '--cross-file-rename',
        },
      })
      lsp.pyright.setup({})
      lsp.tsserver.setup({})
      lsp.cssls.setup({})
      lsp.svelte.setup({})
      lsp.html.setup({})
      lsp.gdscript.setup({})
      lsp.rust_analyzer.setup({})
      lsp.hls.setup({})

      -- ↓ Epitech C Style Checker
      if not configs.ecsls then
        configs.ecsls = {
          default_config = {
            root_dir = lsp.util.root_pattern('.git', 'Makefile'),
            cmd = { 'ecsls_run' },
            autostart = true,
            name = 'ecsls',
            filetypes = { 'c', 'cpp', 'make' },
          },
        }
      end
      lsp.ecsls.setup({})

      lsp_zero.on_attach(function(_, bufnr)
        local opts = {buffer = bufnr, remap = false}

        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'gr', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      lsp_zero.setup()
    end,
  },

  {
    'kosayoda/nvim-lightbulb',
    config = function ()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },

  {
    'ThePrimeagen/refactoring.nvim',
    config = function ()
      require('refactoring').setup({})
    end
  },

  { 'Glench/Vim-Jinja2-Syntax', ft = { 'jinja' } },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup({})
      vim.keymap.set('n', '<leader>x', require('trouble').open, { desc = 'Open all errors' })
    end,
  },

  'sakhnik/nvim-gdb',
}
