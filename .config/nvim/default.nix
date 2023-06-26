{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua require('drawbu')
    '';
    
    plugins = with pkgs.vimPlugins; [
      # Syntax highlighting
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      git
      tree-sitter
      nodejs
      unzip

      # Language Servers
      # Bash
      nodePackages.bash-language-server
      # Lua
      lua-language-server
      # Nix
      nil
      nixpkgs-fmt
      statix
      # Python
      pyright
      black
      # C
      llvmPackages_latest.clang
      clang-tools
      # Typescript
      nodePackages.typescript-language-server
      # Web (ESLint, HTML, CSS, JSON)
      nodePackages.vscode-langservers-extracted
      # Telescope tools
      ripgrep
    ];
  };
}
