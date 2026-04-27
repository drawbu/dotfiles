{ pkgs, lib, ... }:
let
  globalgitignore = pkgs.writeText "globalgitignore" ''
    # Config
    .vscode/
    .idea/
    .claude/
    .codex

    # Cache & env
    __pycache__/
    .?venv/
    .DS_Store
    .env
    .direnv/
    .envrc
    .cache
    .bin/
    compile_commands.json
    .jj
    node_modules/
    target

    ## Executables files
    *.out

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
    lfs.enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILu5dP9F77dUgxHpu7drGx/cMpYPRXw0SjsTOr3sLPBZ"; # op
      signByDefault = true;
    };
    attributes = [ "* merge=mergiraf" ];
    settings = {
      user = {
        email = "git@drawbu.dev";
        name = "Clément";
      };
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
      "url \"ssh://git@gitlab.com/\"".insteadOf = "https://gitlab.com:";
    };
  };

  programs.jujutsu = {
    enable = true;
    package = pkgs.extra.jj;
    settings = {
      "$schema" = "https://docs.jj-vcs.dev/latest/config-schema.json";
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
      git = {
        sign-on-push = true;
        private-commits = "private()";
      };
      ui = {
        default-command = [
          "log"
          "-r"
          "branch_log(@)"
          "--no-pager"
        ];
        conflict-marker-style = "git";
      };
      revset-aliases = {
        "wip()" = "description(regex:'^(?:wip|WIP).*')";
        "mine()" = "author(exact:'git@drawbu.dev')";
        "wip_self()" = "wip() & mine()";
        "private()" = "wip_self() | description(regex:'^(?:private|priv:).*')";
        "branch_log(rev)" = "(trunk()..rev):: | (trunk()..rev)-";
      };
      aliases = {
        drop = [ "abandon" ];
        l = [ "log" ];
        ll = [
          "log"
          "--revisions"
          ".."
        ];
        ls = [
          "log"
          "--summary"
        ];
        main = [
          "log"
          "--revisions"
          "::main"
        ];
        s = [
          "st"
          "--no-pager"
        ];
        wip = [
          "log"
          "--revisions"
          "wip_self()"
          "--no-pager"
        ];
        trunk = [
          "rebase"
          "--destination"
          "trunk()"
        ];
        advance = [
          "bookmark"
          "advance"
          "--to"
          "@-"
        ];
        jj = [
          "util"
          "exec"
          "--"
          "jj"
        ];
        fetch-pr = [
          "util"
          "exec"
          "--"
          (lib.getExe (
            pkgs.writeShellApplication {
              name = "fetch-pr-jj";
              text = ''
                echo "Fetching pull request #$1"
                git fetch origin pull/"$1"/head:pr-"$1"
                jj git import
              '';
            }
          ))
        ];
      };
      templates = {
        git_push_bookmark = "\"clement/push-\" ++ change_id.short()";
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            surround(
              "\nJJ: Parent commit description:\n", "",
              indent("JJ:     ", self.parents().map(|p| p.description()).join("JJ: ---\n")),
            ),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
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
      fix.tools = {
        nixfmt = {
          command = [ "nixfmt" ];
          patterns = [ "glob:'**/*.nix'" ];
        };
        rustfmt = {
          command = [ "rustfmt" ];
          patterns = [ "glob:'**/*.rs'" ];
        };
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
