return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signcolumn = true,
        numhl      = false,
        linehl     = false,
        word_diff  = false,
        on_attach  = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Actions
          map('n', '<leader>gf', gs.diffthis, { desc = 'Diff preview' })
          map('n', '<leader>gu', gs.reset_buffer, { desc = 'Restore file' })
          map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = 'Blame line' })

          map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        end
      })
    end,
  },
}
