-- lazy.nvim is provided on the runtimepath by nix (see default.nix).
require('lazy').setup({
    spec = require('plugins'),
    defaults = { lazy = true },
    install = { colorscheme = { 'catppuccin' } },
    checker = { enabled = false },
    change_detection = { enabled = false },
    performance = {
        reset_packpath = false,
        rtp = { reset = false },
    },
})
