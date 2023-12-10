{ pkgs, ecsls, ... }: {
  home.file = {
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/ftplugin".source = ./ftplugin;
    ".clang-tidy".source = ./.clang-tidy;
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua require('remap')
      lua require('settings')
      lua require('status-line')
      lua require('lazy').setup('plugins')
    '';

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      # Syntax highlighting
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      tree-sitter
      unzip
      nodejs
      ripgrep

      # ↓ Language Servers ↓
      lua-language-server
      nil
      llvmPackages_latest.clang
      clang-analyzer
      clang-tools_16
      pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.svelte-language-server
      ecsls
      gdtoolkit
      rust-analyzer
    ];
  };
}
