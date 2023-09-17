vim.keymap.set('n', '<leader>z', function ()
    require('zen-mode').toggle({
        window = {
            width = 80
        }
    })
end)

