return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup({
      filters = {
        dotfiles = false,
        git_ignored = false,
        no_buffer = false,
        custom = {
          '^\\.git$',
          '^\\.cache',
          '^\\.direnv',
          '^\\.build',
          '^\\.idea$',
          '*.o',
          '.*_templ.go$',
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
}
