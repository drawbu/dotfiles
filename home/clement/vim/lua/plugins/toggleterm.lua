return {
  'akinsho/toggleterm.nvim',
  version = '*',
  priority = 1000,
  config = function()
    local Terminal  = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit || nix run nixpkgs#lazygit',
      hidden = true,
      direction = 'float',
      on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
      end,
    })
    local terminal = Terminal:new({
      hidden = true,
      direction = 'horizontal',
      size = 20,
      on_open = function(term)
        vim.cmd('startinsert!')
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
      end,
    })

    vim.keymap.set('n', '<leader> ', function() terminal:toggle() end, { desc = 'Open a terminal' })
    vim.keymap.set('n', '<leader>gl', function() lazygit:toggle() end, { desc = 'Open lazygit' })
  end,
}
