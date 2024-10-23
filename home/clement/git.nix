{pkgs, ...}: let
  globalgitignore = pkgs.writeText "globalgitignore" ''
    ## MacOS Files
    .DS_Store

    ## Editors
    .vscode/
    .idea/

    ## Python
    __pycache__/
    venv/
    .venv/

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
in {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Clément";
    userEmail = "clement2104.boillot@gmail.com";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      core.excludesFile = "${globalgitignore}";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
      "url \"ssh://git@gitlab.com/\"".insteadOf = "https://gitlab.com/";
    };
  };
}
