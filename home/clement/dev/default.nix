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
      RUSTUP_TOOLCHAIN = "stable";
      CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      RUSTUP_HOME = "${config.home.homeDirectory}/.rustup";
      NPM_PREFIX = "${config.home.homeDirectory}/.npm";
      PNPM_HOME = "${config.home.homeDirectory}/.pnpm";
      NODE_OPTIONS = "--max-old-space-size=8192";
      ANDROID_HOME = "${config.home.homeDirectory}/.local/share/Android/Sdk";
    };

    packages =
      with pkgs;
      [
        # tools
        (hiPrio gcc14) # note: cc from clang & gcc collides
        clang_19
        libcxx
        python312Full
        rustup
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
        linux-manual
        file
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
        tokei
        nix-output-monitor
        lucky-commit

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
        harper
        ijhttp
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
          android-studio
          # jetbrains-toolbox
          zed-editor
          ldtk
        ]
      );
  };
}
