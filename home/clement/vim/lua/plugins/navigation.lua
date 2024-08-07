return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find file' })
      vim.keymap.set('n', '<C-p>', builtin.git_files, {})
      vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Grep search' })
    end,
  },

  {
    'nvim-telescope/telescope-ui-select.nvim',
    after = 'telescope.nvim',
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) }
        }
      }
      require('telescope').load_extension('ui-select')
    end
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    after = { 'telescope.nvim' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({
        settings = { save_on_toggle = true }
      })

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Add to harpoon' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = 'Open harpoon window' })

      vim.keymap.set('n', '<leader>h', function() harpoon:list():prev({ ui_nav_wrap = true }) end,
        { desc = 'Next Harpoon file' })
      vim.keymap.set('n', '<leader>l', function() harpoon:list():next({ ui_nav_wrap = true }) end,
        { desc = 'Previous Harpoon file' })
    end,
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      local ignored = {
        '^%.git$',
        '^%.direnv$',
        '^%.cache$',
        '^%.build$',
        '^%.idea$',
        '%.o$',
        '_templ%.go$',
      }
      require('oil').setup({
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, _)
            for _, pattern in ipairs(ignored) do
              if string.match(name, pattern) then
                return true
              end
            end
            return false
          end,
        }
      })
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory', silent = true })
    end,
  } }
