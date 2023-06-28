return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Visual Git
    use {
        'tanvirtin/vgit.nvim',
        tag = 'v0.2.1',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('drawbu.plugins.vgit')
        end,
    }

    -- Syntax Highlighing
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            require('drawbu.plugins.telescope')
        end,
    }

    -- Highlight other uses of the word
    use 'RRethy/vim-illuminate'

    -- Highlight arguments' definitions and usages
    use 'm-demare/hlargs.nvim'

    -- Lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Catppuccin theme
    use { 
        'catppuccin/nvim',
        as = 'catppuccin',
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    }

    -- Wakatime integration
    use 'wakatime/vim-wakatime'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', 
        tag = '0.1.2',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('drawbu.plugins.telescope')
        end,
    }

    -- Tree of all the changes
    use { 
        'mbbill/undotree',
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    }

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        },
        config = function()
            require('drawbu.plugins.lsp')
        end,
    }

    -- Icons for LSP
    use {
        'onsails/lspkind.nvim',
        config = function()
            require('drawbu.plugins.cmp')
        end,
    }

    -- Distraction free mode
    use {
        'folke/zen-mode.nvim',
        config = function()
            require('drawbu.plugins.zenmode')
        end,
    }

    -- Panel on bottom for keybinds
    use {
        'folke/which-key.nvim',
        config = function()
            require('drawbu.plugins.which-key')
        end,
    }

    -- Terminal in nvim
    use {
        'akinsho/toggleterm.nvim',
        tag = '*',
        config = function()
            require('drawbu.plugins.toggleterm')
        end,
    }

    -- Better indent
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
            }
        end,
    }

    -- File icons
    use 'nvim-tree/nvim-web-devicons'

    -- File tree
    use {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup{
                disable_netrw = false,
                reload_on_bufenter = true,
            }
            vim.keymap.set('n', '<leader>pt', vim.cmd.NvimTreeToggle)
        end,
    }

    use {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('drawbu.plugins.copilot')
        end,
    }

    use {
        'zbirenbaum/copilot-cmp',
        after = { 'copilot.lua' },
        config = function ()
            require('copilot_cmp').setup()
        end
    }

    use {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require('drawbu.plugins.alpha')
        end
    }

    use {
        'terrortylor/nvim-comment',
        config = function ()
            require('nvim_comment').setup({
                create_mappings = true,
                line_mapping = "<leader>:",
            })
        end,
    }
end)

