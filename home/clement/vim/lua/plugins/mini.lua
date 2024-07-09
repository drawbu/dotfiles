return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- Icons
    require('mini.icons').setup({})

    -- Trailing whitespaces
    require('mini.trailspace').setup({})

    -- Start screen
    require('mini.starter').setup({})

    -- Comment lines
    require('mini.comment').setup({})

    -- Move selection in ANY direction
    require('mini.move').setup({
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-Left>',
        right = '<M-Right>',
        down = '<M-Down>',
        up = '<M-Up>',

        -- Move current line in Normal mode
        line_left = '<M-Left>',
        line_right = '<M-Right>',
        line_down = '<M-Down>',
        line_up = '<M-Up>',
      },

      options = {
        reindent_linewise = true,
      },
    })

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
  end
}
