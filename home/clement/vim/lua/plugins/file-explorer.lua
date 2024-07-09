return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    local ignored = {
      '^\\.git$',
      '^\\.cache',
      '^\\.direnv',
      '^\\.build',
      '^\\.idea$',
      '*.o',
      '.*_templ.go$',
    }
    require('oil').setup({
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          for _, pattern in ipairs(ignored) do
            if string.match(name, pattern) then
              return true
            end
          end
          return false
        end,
      }
    })
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory', silent = true })
  end,
}
