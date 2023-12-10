return {{
  'andweeb/presence.nvim',
  config = function ()
    require("presence").setup({
      neovim_image_text   = "God's superior editor.", -- Text displayed when hovered over the Neovim image
    })
  end
}}
