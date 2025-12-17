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
      ".npmrc".text = ''
        update-notifier = false
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
        gcc14
        (lib.hiPrio llvmPackages_latest.clang) # note: cc from clang & gcc collides
        zig
        libcxx
        python314
        rustup
        go
        cargo-mommy
        unstable.cargo-nextest
        cargo-watch
        nodejs
        corepack
        bun
        typescript
        opentofu
        terraform
        lua

        # cool man pages
        man-pages
        man-pages-posix
        stdman

        # random tools
        hyperfine
        tldr
        file
        ripgrep
        fd
        sd
        vgrep
        jq
        bear
        nixpkgs-review
        entr
        ((ffmpeg-full.override { withUnfree = true; }).overrideAttrs (_: {
          doCheck = false;
        }))
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
        postgresql_17
        gum
        uiua
        direnv
        wakatime-cli
        jless
        hydra-check

        # language servers
        lua-language-server
        nixd
        clang-analyzer
        llvmPackages_latest.clang-tools
        llvmPackages_latest.lldb
        pyright
        vscode-langservers-extracted
        emmet-language-server
        tailwindcss-language-server
        nodePackages.typescript-language-server
        nodePackages.svelte-language-server
        nodePackages.bash-language-server
        shellcheck
        shfmt
        gdtoolkit_4
        asm-lsp
        dockerfile-language-server
        docker-compose-language-service
        gopls
        cmake-language-server
        templ
        htmx-lsp
        terraform-ls
        yaml-language-server
        unstable.zls
        haskell-language-server
        graphql-language-service-cli

        typst
        asciinema
        asciinema-agg
        ijhttp
        act
        dive
        yubikey-manager
        temurin-bin
        unstable.gitoxide
        difftastic
        mergiraf
        uv

        # ai bullshit
        unstable.opencode
        unstable.amp-cli
        unstable.gemini-cli
        unstable.claude-code
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        linux-manual
        valgrind
        gdb
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
          jetbrains.goland
          jetbrains-toolbox
          zed-editor
          godot_4
        ])
      );
  };
}
