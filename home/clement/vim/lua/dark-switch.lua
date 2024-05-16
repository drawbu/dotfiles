function dark()
  local themepath = os.getenv('THEMEFILE')
  if themepath then
    local themefile = io.open(themepath, 'r')
    if themefile then
      local theme = themefile:read()
      vim.o.background = (theme == 'light') and 'light' or 'dark'
      themefile:close()
    end
  end
end

dark()

vim.keymap.set('n', '<C-t>', function()
  vim.cmd(':silent exec "!dark 2>/dev/null"')
  dark()
end)
