{ pkgs, ... }: {
  # The packages compatible with macOS and Linux

  home.packages = with pkgs; [
    # cli & tui
    direnv
    bat
    exa
    wakatime
    btop
    neofetch
    tmux
    speedtest-cli
    wget
    git

    # softwares
    discord
    obsidian
    spotify
    vscode

    # fonts
    jetbrains-mono
    nerdfonts

    # local packages
    (pkgs.callPackage ./vera.nix { })
  ];

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
      tree-sitter
      nodejs

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

