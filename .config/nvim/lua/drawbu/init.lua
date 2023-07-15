require('drawbu.settings')
require('drawbu.remap')

-- Epitech don't want you to use plugins for the pool
local function file_exists(name)
   local f = io.open(name, 'r')
   return f ~= nil and io.close(f)
end

if not file_exists('.nvim_clean') then
    require('lazy').setup('drawbu.lazy')
end

