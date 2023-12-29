return {
  'andweeb/presence.nvim',
  lazy = false,
  priority = 1000,
  config = function ()
    require("presence").setup({
      neovim_image_text   = "God's superior editor.", -- Text displayed when hovered over the Neovim image
    })
  end
}
