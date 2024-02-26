return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        filetypes = {
          yaml = true,
          markdown = true,
        },
        suggestion = { enabled = false, },
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
        api_key_cmd = "gpg -q --decrypt " .. home .. "/.openai.txt.gpg",
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
