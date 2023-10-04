-- Trailing whitespaces
require('mini.trailspace').setup({})

-- Start screen
require('mini.starter').setup({})

-- Comment lines
require('mini.comment').setup({})

-- Move selection in ANY direction
require('mini.move').setup({})

-- Patterns highlighting in text
require('mini.hipatterns').setup({})

-- Highlighting of word under cursor
require('mini.cursorword').setup({ delay = 100 })

-- Intent scope
require('mini.indentscope').setup({
    draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
    },
})
