return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Visual Git
    use {
        'tanvirtin/vgit.nvim',
        tag = 'v0.2.1',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }

    -- Syntax Highlighing
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
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
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use 'mbbill/undotree'

    use {
        'folke/neoconf.nvim',
        config = function()
            require('neoconf').setup()
        end,
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    use 'folke/zen-mode.nvim'

    use 'folke/which-key.nvim'

    use {
        'akinsho/toggleterm.nvim',
        tag = '*'
    }

    use 'LnL7/vim-nix'

    use 'lukas-reineke/indent-blankline.nvim'

    use 'nvim-tree/nvim-web-devicons'

    use {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup()
            
            vim.keymap.set('n', '<leader>pt', vim.cmd.NvimTreeToggle)
        end,
    }
end)

