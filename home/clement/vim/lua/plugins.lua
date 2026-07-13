return {
    -- Colorscheme & icons (eager)
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000,
        config = function()
            require('catppuccin').setup {
                transparent_background = true,
                flavour = 'auto',
                background = {
                    light = 'latte',
                    dark = 'mocha',
                },
            }
            vim.cmd('colorscheme catppuccin')
        end,
    },

    { 'f-person/auto-dark-mode.nvim', lazy = false },

    -- UI
    { 'nvim-lualine/lualine.nvim' },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = { preset = 'helix' },
    },

    -- Editing niceties (mini.nvim bundle)
    {
        'nvim-mini/mini.nvim',
        branch = 'stable',
        config = function()
            require('mini.trailspace').setup {}
            require('mini.move').setup {
                mappings = {
                    left = '<M-Left>',
                    right = '<M-Right>',
                    down = '<M-Down>',
                    up = '<M-Up>',
                    line_left = '<M-Left>',
                    line_right = '<M-Right>',
                    line_down = '<M-Down>',
                    line_up = '<M-Up>',
                },
                options = {
                    reindent_linewise = true,
                },
            }
            require('mini.cursorword').setup { delay = 100 }
            require('mini.indentscope').setup {
                draw = {
                    delay = 0,
                    animation = require('mini.indentscope').gen_animation.none(),
                },
            }
            require('mini.bracketed').setup {}
            require('mini.diff').setup {}

            require('mini.icons').setup {}
            require('mini.icons').mock_nvim_web_devicons {} -- lualine/oil/trouble

            require('mini.cmdline').setup {}

            -- Highlight #rrggbb literals and TODO/FIXME/HACK/NOTE keywords.
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup {
                highlighters = {
                    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    },

    -- Navigation
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
        },
        keys = {
            { '<leader>pf', '<cmd>Telescope find_files<cr>', desc = 'Find file' },
            { '<leader>ps', '<cmd>Telescope live_grep<cr>',  desc = 'Grep search' },
            { '<C-p>',      '<cmd>Telescope git_files<cr>',  desc = 'Find git file' },
        },
        init = function()
            local telescope = require('telescope')
            telescope.setup {
                extensions = {
                    ['ui-select'] = { require('telescope.themes').get_dropdown {} }
                }
            }
            telescope.load_extension('ui-select')
        end,
    },

    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>a', function() require('harpoon'):list():add() end,                       desc = 'Add to harpoon' },
            {
                '<C-e>',
                function()
                    local harpoon = require('harpoon')
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = 'Open harpoon window'
            },
            { '<leader>h', function() require('harpoon'):list():prev { ui_nav_wrap = true } end, desc = 'Previous Harpoon file' },
            { '<leader>l', function() require('harpoon'):list():next { ui_nav_wrap = true } end, desc = 'Next Harpoon file' },
        },
        opts = {
            settings = { save_on_toggle = true },
        },
    },

    {
        'stevearc/oil.nvim',
        dependencies = {
            { 'nvim-mini/mini.nvim' },
            {
                'malewicz1337/oil-git.nvim',
                dependencies = { 'stevearc/oil.nvim' },
                opts = {
                    show_ignored_files = true,
                    show_ignored_directories = true,
                    symbols = {
                        file = { ignored = "I" },
                        directory = { ignored = "I" },
                    },
                },
            },
        },
        lazy = false,
        keys = {
            { '-', '<cmd>Oil<cr>', desc = 'Open parent directory', silent = true },
        },
        init = function()
            -- Referenced by the `winbar` option below (needs a global for `v:lua`).
            _G.get_oil_winbar = function()
                local dir = require('oil').get_current_dir()
                if dir then
                    return vim.fn.fnamemodify(dir, ':~')
                end
                return vim.api.nvim_buf_get_name(0)
            end
        end,
        opts = {
            default_file_explorer = true,
            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, _)
                    local ignored = {
                        '^%.%.$',
                        '^%.git$',
                        '^%.jj$',
                        '^%.direnv$',
                        '^%.build$',
                        '^%.idea$',
                        '^%.vscode$',
                        '%.o$',
                        '_templ%.go$',
                        '^%.DS_Store$',
                        '^target$',
                        '^node_modules$',
                        '^dist$',
                        '^%.turbo$',
                        '^%.expo$',
                        '^%.gradle$',
                        '^%.cache[_-]?%g*',
                        '^%.%g+[_-]?cache',
                        '^zig%-out$',
                        '^result$',
                        '^result%-%a+$',
                        '^cmake%-build%-%a+$',
                        '^%.?venv$',
                        '%.egg%-info$',
                        '^__pycache__$',
                        '^%.svelte%-kit$',
                        '^%.react%-router$',
                        '^%.yarn$',
                        '^%.next$',
                        '^%.bin$',
                        '^vendor$',
                    }

                    for _, pattern in ipairs(ignored) do
                        if string.match(name, pattern) then
                            return true
                        end
                    end
                    return false
                end,
            },
            skip_confirm_for_simple_edits = true,
            watch_for_changes = true,
            win_options = {
                winbar = '%!v:lua.get_oil_winbar()',
            },
        },
    },

    -- LSP & diagnostics
    { 'neovim/nvim-lspconfig', event = 'BufReadPre' },

    {
        'kosayoda/nvim-lightbulb',
        event = 'BufReadPost',
        opts = { autocmd = { enabled = true } },
    },

    {
        'folke/trouble.nvim',
        keys = {
            { '<leader>x', '<cmd>Trouble<cr>', desc = 'Open all errors' },
        },
    },

    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        opts = {
            keymap = { preset = 'default' },
            appearance = { nerd_font_variant = 'mono' },
            sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
            completion = { documentation = { auto_show = true } },
            signature = { enabled = true },
        },
        init = function()
            vim.lsp.config('*', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
            })
        end
    },

    -- Misc
    {
        'mbbill/undotree',
        keys = {
            { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Undo tree' },
        },
    },

    { 'wakatime/vim-wakatime', event = 'VeryLazy' },
}
