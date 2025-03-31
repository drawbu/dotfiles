{
  pkgs,
  config,
  graphical,
  lib,
  ...
}:
{
  imports = [ ./editorconfig.nix ];

  manual = {
    manpages.enable = true;
    html.enable = true;
  };

  programs.man = {
    enable = true;
    # generateCaches = true;
  };

  home = {
    file = {
      ".clang-tidy".source = ./.clang-tidy;
      ".clang-format".source = ./.clang-format;
      ".clangd".source = ./.clangd;
    };

    activation = {
      "npm_prefix" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.lib.getExe' pkgs.nodejs "npm"} config set \
            prefix="${config.home.sessionVariables.NPM_PREFIX}/bin"
      '';
    };

    sessionPath = [
      "$NPM_PREFIX/bin"
      "$PNPM_HOME"
      "${config.home.homeDirectory}/.local/bin"
      "$ANDROID_HOME/platform-tools"
    ];

    sessionVariables = {
      # Rust
      CARGO_NET_GIT_FETCH_WITH_CLI = "true";
      # RUSTUP_TOOLCHAIN = "stable";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
      NPM_PREFIX = "${config.home.homeDirectory}/.npm";
      PNPM_HOME = "${config.home.homeDirectory}/.pnpm";
      NODE_OPTIONS = "--max-old-space-size=8192";
      ANDROID_HOME = "${config.home.homeDirectory}/.local/share/Android/Sdk";

      # Drop when version 31 drops.
      # https://github.com/nodejs/corepack/issues/612#issuecomment-2631462297
      COREPACK_INTEGRITY_KEYS = 0;
    };

    packages =
      with pkgs;
      [
        # tools
        gcc14
        (hiPrio clang_19) # note: cc from clang & gcc collides
        zig
        libcxx
        python312Full
        rustup
        go
        cargo-mommy
        nodejs
        corepack
        typescript
        opentofu
        lua

        # cool man pages
        man-pages
        man-pages-posix
        stdman

        # random tools
        hyperfine
        tldr
        # linux-manual
        file
        ripgrep
        fd
        vgrep
        jq
        bear
        unstable.lazygit
        nixpkgs-review
        entr
        ffmpeg
        # valgrind
        # gdb
        cmake
        gnumake
        gcovr
        nixfmt-rfc-style
        alejandra
        pkg-config
        just
        kubectl
        whois
        tokei
        nix-output-monitor
        lucky-commit
        unstable.jujutsu
        postgresql_17
        gum
        uiua

        # language servers
        lua-language-server
        unstable.nixd
        clang-analyzer
        clang-tools_19
        pyright
        vscode-langservers-extracted
        unstable.emmet-language-server
        unstable.tailwindcss-language-server
        nodePackages.typescript-language-server
        nodePackages.svelte-language-server
        nodePackages.bash-language-server
        shellcheck
        shfmt
        # ecsls
        gdtoolkit_4
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
        haskell-language-server
        ijhttp
      ]
      ++ lib.optionals graphical (
        [
          wine64Packages.waylandFull
          msitools
          ldtk
        ]
        ++ (with unstable; [
          # softs
          vscode
          jetbrains.pycharm-professional
          jetbrains.webstorm
          jetbrains.datagrip
          jetbrains.rust-rover
          jetbrains-toolbox
          zed-editor
          godot_4
        ])
      );
  };
}
