{ pkgs, ... }:
{
  imports = [ ./vim.nix ];
  xdg.configFile = {
    "nvim/lua".source = ./lua;
    "nvim/ftplugin".source = ./ftplugin;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      vim.cmd [[
      ${builtins.readFile ./.vimrc}
      ]]

      require('dark-switch')
      require('lazy').setup {
        spec = { { import = "plugins" } },
        performance = {
          reset_packpath = false,
          rtp = { reset = false }
        },
      }

      -- ↓ Indent
      vim.g.python_indent = {
        open_paren = 'shiftwidth()',
        closed_paren_align_last_line = true,
      }

      -- ↓ Search
      vim.opt.incsearch = true

      -- ↓ Curor never touching borders
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99 -- Minimum number of screen line below and above the cursor
      vim.opt.foldenable = true
      vim.opt.scrolloff = 99

      vim.cmd([[
        " Infinite undo
        if has('persistent_undo')
            set undodir=$HOME/.nvim/undo
            set undofile
        endif

        augroup FileTypeOverride
          autocmd!
          autocmd BufRead,BufNewFile *.asm set filetype=nasm
        augroup END
      ]])
    '';

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];
  };
}
