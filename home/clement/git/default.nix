{...}: {
  home.file.".globalgitignore".source = ./.globalgitignore;

  programs.git = {
    enable = true;
    userName = "Clément";
    userEmail = "clement2104.boillot@gmail.com";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      core.excludesFile = "~/.globalgitignore";
      push.autoSetupRemote = true;
      "url \"ssh://git@github.com/\"".insteadOf = "https://github.com/";
      "url \"ssh://git@gitlab.com/\"".insteadOf = "https://gitlab.com/";
    };
  };
}
