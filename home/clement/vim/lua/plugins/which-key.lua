return {
  'folke/which-key.nvim',
  priority = 1000,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require('which-key')

    wk.add({
      { "<leader>d",  group = "gdb" },
      { "<leader>g",  group = "git" },
      { "<leader>p",  group = "project" },
      { "<leader>pp", desc = "Open directory" },
    })
  end,
}
