{ pkgs, ... }:
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
    compile_commands.json

    ## Executables files
    *.out
    main

    ## Nix
    result
    result-*
  '';
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Clément";
    userEmail = "git@drawbu.dev";
    lfs.enable = true;
    signing = {
      key = "~/.ssh/id_ed25519_sk.pub"; # ssh-keygen -K
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "ssh";
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
      merge.conflictStyle = "zdiff3";
      diff = {
        algorithm = "histogram";
        mnemonicPrefix = true;
        renames = "true";
      };
      alias.l = "log --oneline --decorate --graph";
      gitbutler.signCommits = true;
      "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
      "url \"ssh://git@gitlab.com/\"".insteadOf = "https://gitlab.com/";
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
