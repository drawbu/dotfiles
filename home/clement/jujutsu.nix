{
  config,
  finputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ finputs.jj-mesh.homeModules.default ];

  services.jj-mesh.enable = true;

  programs.jujutsu = {
    enable = true;
    package = pkgs.extra.jj;
    settings = {
      user = { inherit (config.programs.git.settings.user) name email; };

      git = {
        sign-on-push = true;
        private-commits = "private()";
      };

      ui = {
        default-command = [
          "log"
          "-r"
          "branch_log(@) ~ idle_workspaces()"
          "--no-pager"
        ];
        conflict-marker-style = "git";
      };

      remotes.origin.auto-track-bookmarks = "glob:'clement/*' | 'main' | 'master'";

      revset-aliases = {
        "wip()" = "description(regex:'^(?:wip|WIP).*')";
        "mine()" = "author(regex:'@drawbu\\.dev$')";
        "wip_self()" = "wip() & mine()";
        "private()" = "wip_self() | description(regex:'^(?:private|priv:).*')";
        "branch_log(rev)" = "(trunk()..rev):: | (trunk()..rev)-";
        "branch_start(to)" = "heads(::to & trunk())+ & ::to";
        "idle_workspaces()" = "visible_heads() & working_copies() & empty() & description(exact:'') ~ @";
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
        main = [
          "log"
          "--revisions"
          "trunk()"
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
        w = [
          "util"
          "exec"
          "--"
          "jj-workspace"
        ];
        # credit: https://github.com/icorbrey/dotnix/blob/main/modules%2Fhome%2Fjujutsu%2Fdefault.nix#L117
        restack = [
          "rebase"
          "-o"
          "trunk()"
          "-s"
          "roots(trunk()..) & mutable()" # mutable roots
        ];
        # credit: https://github.com/mrnugget/dotfiles/blob/8040ade4018a1c619748aabb794256b6773ff81e/jj_config.toml#L23
        collapse = [
          "squash"
          "-f"
          "branch_start(@)+::@"
          "-t"
          "branch_start(@)"
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
          command = [
            "nixfmt"
            "-"
            "--filename=$path"
          ];
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
    }
    // lib.optionalAttrs config.mod.onepassword.enable {
      signing = {
        behavior = "drop";
        backend = "ssh";
        inherit (config.programs.git.signing) key;
        backends.ssh.program = config.mod.onepassword.signer;
      };
    };
  };

  programs.zsh.initContent = ''
    jj-workspace-switch-widget() {
      setopt localoptions pipefail no_aliases 2> /dev/null
      local root
      root=$(
        jj-workspace list --color 2> /dev/null \
          | fzf --delimiter='\t' --ansi --with-nth=1,2 --accept-nth=3 --exit-0 --reverse \
              --height="''${FZF_TMUX_HEIGHT:-40%}" \
              --footer='del: remove  alt-u: update stale' \
              --preview='jj log --ignore-working-copy --color=always -r {1}@-::{1}@' \
              --bind="del:transform-header[
                if test {3} = \"\$(jj root)\"; then
                  echo 'cannot remove the current workspace'
                else
                  jj-workspace remove {3} 2>&1 && echo 'removed {1}'
                fi
              ]+reload:jj-workspace list --color" \
              --bind="alt-u:transform-header[jj workspace update-stale --repository {3} 2>&1]"
      )
      if [[ -z "$root" ]] || ! builtin cd -- "$root"; then
        zle redisplay
        return 0
      fi
      zle reset-prompt
    }

    jj-workspace-new-widget() {
      setopt localoptions no_aliases 2> /dev/null
      local out
      jj root &> /dev/null || return 0
      if ! out=$(jj-workspace add 2>&1) || ! builtin cd -- "''${out##*$'\n'}"; then
        zle -M "$out"
        return 1
      fi
      zle reset-prompt
      [[ "$out" != *$'\n'* ]] || zle -M "''${out%$'\n'*}"
    }

    zle -N jj-workspace-switch-widget
    zle -N jj-workspace-new-widget
    for keymap in emacs vicmd viins; do
      bindkey -M $keymap '^W' jj-workspace-switch-widget
      bindkey -M $keymap '^N' jj-workspace-new-widget
    done
    unset keymap
  '';
}
