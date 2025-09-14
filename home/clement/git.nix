{ pkgs, lib, ... }:
let
  globalgitignore = pkgs.writeText "globalgitignore" ''
    ## MacOS Files
    .DS_Store

    ## Editors
    .vscode/
    .idea/

    ## Python
    __pycache__/
    .?venv/

    ## Environment files
    .env
    .direnv/
    .envrc
    .cache
    .bin/
    compile_commands.json

    ## Executables files
    *.out
    main

    ## Nix
    result
    result-*
  '';
  ssh1password =
    if pkgs.stdenv.isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      lib.getExe' pkgs._1password-gui "op-ssh-sign";
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Clément";
    userEmail = "git@drawbu.dev";
    lfs.enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILu5dP9F77dUgxHpu7drGx/cMpYPRXw0SjsTOr3sLPBZ"; # op
      signByDefault = true;
    };
    attributes = [ "* merge=mergiraf" ];
    extraConfig = {
      gpg.format = "ssh";
      "gpg \"ssh\"".program = ssh1password;
      init.defaultBranch = "main";
      core.excludesFile = toString globalgitignore;
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      column.ui = "auto";
      tag.sort = "version:refname";
      branch.sort = "-committerdate";
      help.autocorrect = "prompt";
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      rebase = {
        autoStash = true;
        updateRefs = true;
      };
      merge.conflictStyle = "diff3";
      merge.mergiraf = {
        name = "mergiraf";
        driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
      };
      ui.diff-editor = ":builtin";
      diff = {
        algorithm = "histogram";
        mnemonicPrefix = true;
        renames = "true";
        external = "difft";
      };
      alias.l = "log --oneline --decorate --graph";
      gitbutler.signCommits = true;
      "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
      "url \"ssh://git@gitlab.com/\"".insteadOf = "https://gitlab.com/";
    };
  };

  programs.jujutsu = {
    enable = true;
    package = pkgs.extra.jj;
    settings = {
      "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json";
      user = {
        name = "Clément";
        email = "git@drawbu.dev";
      };
      signing = {
        behavior = "drop";
        backend = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILu5dP9F77dUgxHpu7drGx/cMpYPRXw0SjsTOr3sLPBZ";
        backends.ssh.program = ssh1password;
      };
      git.sign-on-push = true;
      ui.default-command = [
        "log"
        "-r"
        "(main..@):: | (main..@)-"
        "--no-pager"
      ];
      aliases = {
        drop = [ "abandon" ];
        l = [ "log" ];
        ll = [
          "log"
          "-r"
          ".."
        ];
        ls = [
          "log"
          "--summary"
        ];
        main = [
          "log"
          "-r"
          "::main"
        ];
        s = [
          "st"
          "--no-pager"
        ];
      };
      template-aliases = {
        "format_timestamp(timestamp)" = ''
          if(timestamp.before("1 week ago"),
            timestamp.ago() ++ timestamp.format(" (%Y-%m-%d at %H:%M)"),
            timestamp.ago()
          )
        '';
        "format_short_signature(signature)" = ''
          if(signature.email().domain().ends_with("users.noreply.github.com"),
            signature.name() ++ ' (GitHub)',
            signature.email(),
          )
        '';
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        showNumstatInFilesView = true;
        showDivergenceFromBaseBranch = "arrowAndNumber";
      };
      git = {
        overrideGpg = true;
        disableForcePushing = true;
        mainBranches = [
          "master"
          "main"
          "develop"
        ];
      };
      update.method = "never";
      notARepository = "quit";
    };
  };

  home.packages = with pkgs; [ git-open ];
}
