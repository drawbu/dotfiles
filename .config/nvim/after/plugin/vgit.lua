local vgit = require('vgit')

vgit.setup({
    keymaps = {
        ['n <leader>gf'] = function() vgit.buffer_diff_preview() end,
        ['n <leader>gh'] = function() vgit.buffer_history_preview() end,
        ['n <leader>gu'] = function() vgit.buffer_reset() end,
    }
})

