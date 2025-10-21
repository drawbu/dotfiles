local function sync_system_theme()
  local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
  if handle == nil then return end
  local theme = handle:read("*a")
  handle:close()
  vim.o.background = (theme == "'prefer-light'\n" ) and 'light' or 'dark'
end

sync_system_theme()

vim.keymap.set('n', '<C-t>', function()
  vim.cmd(':silent exec "!dark 2>/dev/null"')
  sync_system_theme()
end)
