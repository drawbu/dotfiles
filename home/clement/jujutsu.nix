{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    package = pkgs.extra.jj;
    settings = {
      user = {
        name = "Clément";
        email = "git@drawbu.dev";
      };

      signing = {
        behavior = "drop";
        backend = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILu5dP9F77dUgxHpu7drGx/cMpYPRXw0SjsTOr3sLPBZ";
        backends.ssh.program = config.programs.git.settings.gpg.ssh.program;
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

      revsets = {
        "bookmark-advance-to" = "heads(::@ & ~private() & ~description(''))";
      };

      aliases = {
        difft = [
          "show"
          "--tool"
          "difft"
        ];
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
        ];
        jj = [
          "util"
          "exec"
          "--"
          "jj"
        ];
        exec = [
          "util"
          "exec"
          "--"
          "jj-exec"
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
        clang-format = {
          command = [ "clang-format" ];
          patterns = [ "glob:'**/*.{c,h,cpp,hpp}'" ];
        };
        jupyter = {
          command = [
            "jq"
            "--indent"
            "1"
            "-S"
            "(.cells[].metadata) = {} | (.metadata) = {} | (.cells[] | select(.cell_type == \"code\")) |= (.execution_count = null | .outputs = [])"
          ];
          patterns = [ "glob:'**/*.ipynb'" ];
        };
      };
    };
  };
}
