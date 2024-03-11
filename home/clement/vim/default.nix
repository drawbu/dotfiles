{ pkgs, ecsls, ... }: {
  imports = [
    ./vim.nix
  ];
  home.file = {
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/ftplugin".source = ./ftplugin;
    ".clang-tidy".source = ./.clang-tidy;
    ".clang-format".source = ./.clang-format;
    ".clangd".source = ./.clangd;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.readFile ./.vimrc + ''
      lua require('settings')
      lua require('lazy').setup('plugins')
    '';

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      tree-sitter
      ripgrep

      # ↓ Language Servers ↓
      lua-language-server
      nil
      llvmPackages_latest.clang
      clang-analyzer
      clang-tools_17
      pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.svelte-language-server
      ecsls
      gdtoolkit
      rust-analyzer
      haskell-language-server
      asm-lsp
      dockerfile-language-server-nodejs
      docker-compose-language-service
      gopls
    ];
  };
}
