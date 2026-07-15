-- Colorscheme -----------------------------------------------------------------
require('catppuccin').setup {
    transparent_background = true,
    flavour = 'auto',
    background = {
        light = 'latte',
        dark = 'mocha',
    },
}
vim.cmd('colorscheme catppuccin')

-- UI --------------------------------------------------------------------------
require('lualine').setup {}

require('which-key').setup { preset = 'helix' }

-- Editing niceties (mini.nvim) ------------------------------------------------
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

-- Navigation ------------------------------------------------------------------
local telescope = require('telescope')
telescope.setup {
    extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown {} },
    },
}
telescope.load_extension('ui-select')

vim.keymap.set('n', '<leader>pf', '<cmd>Telescope find_files<cr>', { desc = 'Find file' })
vim.keymap.set('n', '<leader>ps', '<cmd>Telescope live_grep<cr>', { desc = 'Grep search' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<cr>', { desc = 'Find git file' })

local harpoon = require('harpoon')
harpoon.setup {
    settings = { save_on_toggle = true },
}
vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Add to harpoon' })
vim.keymap.set('n', '<C-e>', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Open harpoon window' })
vim.keymap.set('n', '<leader>h', function() harpoon:list():prev { ui_nav_wrap = true } end, { desc = 'Previous Harpoon file' })
vim.keymap.set('n', '<leader>l', function() harpoon:list():next { ui_nav_wrap = true } end, { desc = 'Next Harpoon file' })

-- Referenced by oil's `winbar` option below (needs a global for `v:lua`).
_G.get_oil_winbar = function()
    local dir = require('oil').get_current_dir()
    if dir then
        return vim.fn.fnamemodify(dir, ':~')
    end
    return vim.api.nvim_buf_get_name(0)
end

require('oil').setup {
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
}
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory', silent = true })

require('oil-git').setup {
    show_ignored_files = true,
    show_ignored_directories = true,
    symbols = {
        file = { ignored = 'I' },
        directory = { ignored = 'I' },
    },
}

-- LSP & diagnostics -----------------------------------------------------------
-- `nvim-lspconfig` only ships the `lsp/*` config files consumed by
-- `vim.lsp.enable` (see config/lsp.lua); it needs no `setup` call.

require('nvim-lightbulb').setup { autocmd = { enabled = true } }

vim.keymap.set('n', '<leader>x', '<cmd>Trouble<cr>', { desc = 'Open all errors' })

require('blink.cmp').setup {
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
}
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Misc ------------------------------------------------------------------------
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { desc = 'Undo tree' })
