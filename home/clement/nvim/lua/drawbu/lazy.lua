local vim = vim

return {
    -- Catppuccin theme
    {
        'catppuccin/nvim',
        as = 'catppuccin',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    },

    -- ↓ Gruvbox theme
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000 ,
        config = true,
    },

    {
        'xiyaowong/transparent.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('TransparentEnable')
        end
    },

    -- Visual Git
    {
        'tanvirtin/vgit.nvim',
        version = 'v0.2.1',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('drawbu.plugins.vgit')
        end,
    },

    -- Syntax Highlighing
    {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        tag = 'v0.9.1',
        config = function()
            require('drawbu.plugins.treesitter')
        end,
    },

    -- Wakatime integration
    'wakatime/vim-wakatime',

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('drawbu.plugins.telescope')
        end,
    },

    -- Tree of all the changes
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end,
    },

    -- Completion
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
            require('drawbu.plugins.cmp')
        end,
    },

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        after = { 'nvim-cmp' },
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
        },
        config = function()
            require('drawbu.plugins.lsp')
        end,
    },

    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        after = { 'lsp-zero.nvim' },
        config = function()
            require('lsp_lines').setup()
            vim.diagnostic.config({ virtual_text = false })
            vim.keymap.set(
                '',
                '<Leader>t',
                require('lsp_lines').toggle,
                { desc = 'Toggle lsp_lines' }
            )
        end,
    },

    -- Distraction free mode
    {
        'folke/zen-mode.nvim',
        config = function()
            require('drawbu.plugins.zenmode')
        end,
    },

    -- Panel on bottom for keybinds
    {
        'folke/which-key.nvim',
        config = function()
            require('drawbu.plugins.which-key')
        end,
    },

    -- Terminal in nvim
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        config = function()
            require('drawbu.plugins.toggleterm')
        end,
    },

    -- ↓ File explorer
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('nvim-tree').setup()
        end,
    },

    -- ↓ Move around the files
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('drawbu.plugins.harpoon')
        end,
    },

    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('drawbu.plugins.copilot')
        end,
    },

    {
        'zbirenbaum/copilot-cmp',
        after = { 'copilot.lua' },
        config = function ()
            require('copilot_cmp').setup()
        end
    },

    -- ↓ Editorconfig support
    'gpanders/editorconfig.nvim',

    -- ↓ See all the errors
    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('trouble').setup {}
            vim.keymap.set('n', '<leader>x', function() require('trouble').open() end)
        end,
    },

    -- ↓ Easy navigation between neovim & tmux
    'christoomey/vim-tmux-navigator',

    -- ↓ Jinja support
    { 'Glench/Vim-Jinja2-Syntax', ft = { 'jinja' } },

    -- ↓ Lots of nice stuff
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function ()
            require('drawbu.plugins.mini')
        end
    },

    -- ↓ Epitech plugin
    'drawbu/vim-epitech',
}

