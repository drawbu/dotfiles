{ pkgs, ecsls, ... }: {
  home.file = {
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/ftplugin".source = ./ftplugin;
    ".clang-tidy".source = ./.clang-tidy;
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua require('drawbu')
    '';

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      # Syntax highlighting
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      git
      tree-sitter
      unzip
      nodejs
      lazygit

      # ↓ Language Servers ↓
      # Lua
      lua-language-server
      # Nix
      nil
      # C
      llvmPackages_latest.clang
      clang-tools
      clang-analyzer
      # Python
      pyright
      # Typescript
      nodePackages.typescript-language-server
      # CSS
      nodePackages.vscode-langservers-extracted
      # Svelte
      nodePackages.svelte-language-server
      # Epitech Coding Style
      ecsls

      # Telescope tools
      ripgrep
    ];
  };
}
