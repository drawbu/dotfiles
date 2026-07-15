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
      require('config.plugins')
      require('config.lsp')
    '';

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars

      # Shared dependency.
      plenary-nvim

      # Colorscheme & icons.
      catppuccin-nvim
      auto-dark-mode-nvim

      # Editing niceties bundle.
      mini-nvim

      # UI
      lualine-nvim
      which-key-nvim

      # Navigation
      telescope-nvim
      telescope-ui-select-nvim
      harpoon2
      oil-nvim
      (oil-git-nvim.overrideAttrs (_: {
        src = pkgs.fetchFromGitHub {
          owner = "malewicz1337";
          repo = "oil-git.nvim";
          tag = "v1.0.1";
          hash = "sha256-OsQLV+6+sI2YaSSSVz7TRNHaqUCGfRCyfCTZQyaRCAE=";
        };
      }))

      # LSP & diagnostics
      nvim-lspconfig
      nvim-lightbulb
      trouble-nvim
      blink-cmp
      friendly-snippets

      # Misc
      undotree
      vim-wakatime
    ];
  };
}
