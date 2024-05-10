{
  pkgs,
  ecsls,
  config,
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
      cmake
      gnumake
      gcovr
      libcxx
      python312Full
      rustup
      nodejs_21
      corepack_21
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
      unstable.lazygit
      nixpkgs-review
      entr

      # language servers
      lua-language-server
      nil
      clang-analyzer
      clang-tools_17
      pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
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
    ];
  };
}
