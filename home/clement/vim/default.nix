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

    initLua = ''
      vim.cmd.source('${./common.vim}')

      vim.opt.scrolloff = 99

      vim.opt.undodir = vim.fn.expand('$HOME/.nvim/undo')
      vim.opt.undofile = true

      require('config.treesitter')
      require('config.lazy')
      require('config.lsp')
    '';

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];
  };
}
