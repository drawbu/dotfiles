return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  -- Visual Git
  use {
    'tanvirtin/vgit.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }
  
  -- One Dark Pro colorscheme
  use 'navarasu/onedark.nvim'
  
  -- Syntax Highlighing
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
  }

  -- Highlight other uses of the word
  use 'RRethy/vim-illuminate'
  
  -- Highlight arguments' definitions and usages
  use 'm-demare/hlargs.nvim'

  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
end)
