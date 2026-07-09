{
  pkgs,
  config,
  graphical,
  lib,
  ...
}:
{
  imports = [
    ./editorconfig.nix
    ./agents
  ];

  manual = {
    manpages.enable = true;
    html.enable = true;
  };

  programs = {
    man.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
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
      AGENT_BROWSER_EXECUTABLE_PATH = lib.getExe pkgs.chromium;
    };

    packages =
      with pkgs;
      [
        # tools
        gcc14
        (lib.hiPrio llvmPackages_latest.clang) # note: cc from clang & gcc collides
        zig
        libcxx
        (python314.withPackages (
          ps: with ps; [
            requests
            pytest
            black
            pillow
          ]
        ))
        rustup
        go
        cargo-mommy
        cargo-nextest
        cargo-watch
        cargo-audit
        cargo-auditable
        nodejs_latest
        corepack
        bun
        deno
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
        nixfmt
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
        patchutils
        poppler-utils

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
        typescript-language-server
        svelte-language-server
        bash-language-server
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
        zls
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
        gitoxide
        difftastic
        mergiraf
        uv
        ruff
        ty
        cloudflared
        agent-browser
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
          jetbrains.pycharm
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
