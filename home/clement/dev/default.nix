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

    sessionPath = [
      "$CARGO_HOME/bin"
      "$RUSTUP_HOME/toolchains/$RUSTUP_TOOLCHAIN-x86_64-unknown-linux-gnu/bin"
      "$NPM_PREFIX/bin"
      "${config.home.homeDirectory}/.local/bin"
    ];

    sessionVariables = rec {
      # Rust
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      RUSTUP_TOOLCHAIN = "stable";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";

      NPM_PREFIX = "${config.home.homeDirectory}/.npm";
      NODE_OPTIONS = "--max-old-space-size=8192";
    };

    packages =
      with pkgs;
      [
        # tools
        (hiPrio gcc14) # note: cc from clang & gcc collides
        unstable.clang_19
        libcxx
        python312Full
        rustup
        # nodejs_latest
        nodejs_20
        # corepack_latest
        corepack_20
        typescript
        unstable.opentofu
        lua

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
        whois

        # language servers
        lua-language-server
        unstable.nixd
        clang-analyzer
        unstable.clang-tools_19
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
        terraform-ls
        yaml-language-server
        unstable.zls
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
