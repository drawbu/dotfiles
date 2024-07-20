{
  pkgs,
  config,
  graphical,
  ...
}: {
  imports = [./editorconfig.nix];

  home = {
    file = {
      ".clang-tidy".source = ./.clang-tidy;
      ".clang-format".source = ./.clang-format;
      ".clangd".source = ./.clangd;
    };

    sessionVariables = {
      # Rust
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      RUSTC_VERSION = "stable";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
      PATH = "$PATH:$CARGO_HOME/bin:$RUSTUP_HOME/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/";
    };

    packages = with pkgs; [
      # tools
      gcc13
      libcxx
      python312Full
      rustup
      nodejs_22
      corepack_22
      typescript

      # man pages
      man-pages
      man-pages-posix
      stdman

      # random tools
      hyperfine
      tldr
      linux-manual
      ripgrep
      fd
      vgrep
      jq
      bear
      lazygit
      nixpkgs-review
      entr
      ffmpeg
      valgrind
      gdb
      cmake
      gnumake
      gcovr
      nixfmt-rfc-style
      alejandra

      # language servers
      lua-language-server
      nil
      clang-analyzer
      clang-tools_18
      pyright
      vscode-langservers-extracted
      emmet-language-server
      tailwindcss-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      nodePackages.bash-language-server
      shellcheck
      ecsls
      gdtoolkit
      haskell-language-server
      asm-lsp
      dockerfile-language-server-nodejs
      docker-compose-language-service
      gopls
      cmake-language-server
      templ
    ] ++ lib.optionals graphical [
      # softs
      vscode
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      jetbrains.datagrip
      jetbrains.goland
      unstable.zed-editor
    ];
  };
}
