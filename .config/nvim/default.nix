{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraConfig = ''
      lua require('drawbu')
    '';
    
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      # Syntax highlighting
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      git
      tree-sitter
      unzip
      nodejs

      # Language Servers
      # Lua
      lua-language-server
      # Nix
      nil
      # C
      llvmPackages_latest.clang
      clang-tools
      # Telescope tools
      ripgrep
    ];
  };
}
