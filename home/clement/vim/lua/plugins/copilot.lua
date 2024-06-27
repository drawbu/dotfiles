return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        disable_inline_completion = true,
        disable_keymaps = true,
      })
    end,
  },

  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      local home = vim.fn.expand("$HOME")
      local model = "gpt-4-turbo-preview"
      require("chatgpt").setup({
        api_key_cmd = "gpg -r clement2104.boillot@gmail.com -q --decrypt " .. home .. "/.openai.txt.gpg",
        openai_params = { model = model },
        openai_edit_params = { model = model },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }
}
