return {{
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup({
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {
          '^\\.git$',
          '^\\.cache',
          '^\\.direnv',
          '^\\.build',
        },
      },
      renderer = {
        icons = {
          glyphs = {
            git = {
              ignored = "-",
            }
          }
        }
      },
    })
  end,
}}
