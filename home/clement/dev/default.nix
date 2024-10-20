{
  pkgs,
  config,
  graphical,
  lib,
  ...
}:
{
  imports = [ ./editorconfig.nix ];

  home = {
    file = {
      ".clang-tidy".source = ./.clang-tidy;
      ".clang-format".source = ./.clang-format;
      ".clangd".source = ./.clangd;
    };

    activation = {
      "npm_prefix" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.lib.getExe' pkgs.nodejs_latest "npm"} config set \
            prefix="${config.home.sessionVariables.NPM_PREFIX}/bin"
      '';
    };

    sessionVariables = {
      # Rust
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      RUSTC_VERSION = "stable";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";

      NPM_PREFIX = "${config.home.homeDirectory}/.npm";

      PATH = "$PATH:${
        pkgs.lib.makeBinPath [
          "$CARGO_HOME"
          "$RUSTUP_HOME/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu"
          "$NPM_PREFIX"
          "$HOME/.local"
        ]
      }";
    };

    packages =
      with pkgs;
      [
        # tools
        gcc14
        libcxx
        python312Full
        rustup
        nodejs_latest
        corepack_latest
        typescript
        unstable.opentofu

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
        pkg-config
        just
        kubectl
        terraform-ls
        yaml-language-server

        # language servers
        lua-language-server
        unstable.nixd
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
        # ecsls
        gdtoolkit
        asm-lsp
        dockerfile-language-server-nodejs
        docker-compose-language-service
        gopls
        cmake-language-server
        templ
        htmx-lsp
      ]
      ++ lib.optionals graphical (
        with unstable;
        [
          # softs
          vscode
          jetbrains.clion
          jetbrains.pycharm-professional
          jetbrains.webstorm
          jetbrains.datagrip
          jetbrains.goland
          jetbrains.rust-rover
          jetbrains-toolbox
          zed-editor
        ]
      );
  };
}
