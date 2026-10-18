{ config, pkgs, ... }:
let
  jj-workspace = pkgs.writeShellApplication {
    name = "jj-workspace";
    runtimeInputs = [ config.programs.jujutsu.package ];
    text = ''
      usage() {
        printf 'Usage: jj-workspace add <path> [<rev>]\n' >&2
        printf '       jj-workspace remove <path>\n' >&2
        printf '\nManage throwaway workspaces of the current repository.\n' >&2
        printf '  add      Create a workspace named <hostname>-<basename> on <rev>\n' >&2
        printf '           (default: @, or @- when @ has no changes)\n' >&2
        printf '  remove   Forget the workspace and delete <path>\n' >&2
        exit 1
      }

      add() {
        local path=$1 revision=''${2:-}
        local repo_root
        repo_root=$(jj root)

        if [[ -z "$revision" ]]; then
          revision='@'
          if [[ -z "$(jj diff --repository "$repo_root" -r @ --summary)" ]]; then
            revision='@-'
          fi
        fi

        local commit
        commit=$(jj log --repository "$repo_root" -r "$revision" --no-graph --template commit_id)

        mkdir -p "$(dirname "$path")"
        jj workspace add --quiet \
          --repository "$repo_root" \
          --name "$HOSTNAME-$(basename "$path")" \
          --revision "$commit" \
          "$path" >/dev/null

        for dir in .claude local; do
          if [[ -e "$repo_root/$dir" ]]; then
            ln -s "$repo_root/$dir" "$path/$dir"
          fi
        done

        if [[ -d "$repo_root/target" ]] &&
          ! cp -a --reflink=always "$repo_root/target" "$path/target" 2>/dev/null; then
          printf 'jj-workspace: cannot reflink target/, starting cold\n' >&2
          rm -rf "$path/target"
        fi
      }

      remove() {
        local path=$1
        jj util snapshot --quiet --repository "$path"
        jj workspace forget --quiet --repository "$path"
        rm -rf "$path"
      }

      [[ $# -ge 2 ]] || usage
      case "$1" in
        add) [[ $# -le 3 ]] || usage; add "$2" "''${3:-}" ;;
        remove) [[ $# -eq 2 ]] || usage; remove "$2" ;;
        *) usage ;;
      esac
    '';
  };
in
{
  home.packages = [
    jj-workspace
    (pkgs.writeShellApplication {
      name = "jj-exec";
      runtimeInputs = [
        config.programs.jujutsu.package
        jj-workspace
      ];
      text = ''
        usage() {
          printf 'Usage: jj exec [-r <rev>] [--] <cmd> [<args>...]\n' >&2
          printf '\nRun <cmd> in a temporary jj workspace.\n' >&2
          printf '  -r <rev>   Parent revision for the workspace (default: @, or @- when @ has no changes)\n' >&2
          exit 1
        }

        REVISION=""
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -r)
              [[ $# -ge 2 ]] || { printf 'jj-exec: -r requires an argument\n' >&2; exit 1; }
              REVISION="$2"
              shift 2
              ;;
            --)
              shift
              break
              ;;
            -*)
              printf 'jj-exec: unknown option: %s\n' "$1" >&2
              usage
              ;;
            *)
              break
              ;;
          esac
        done

        [[ $# -ge 1 ]] || usage

        WORKTREE=$(mktemp -d -t jj-exec-XXXX)
        BASE_COMMIT=""

        cleanup() {
          local exit_code=$?
          trap \'\' INT
          set +e

          if [[ -n "$BASE_COMMIT" ]] \
            && [[ -n "$(jj diff --repository "$WORKTREE" --from "$BASE_COMMIT" --summary 2>/dev/null)" ]]; then
            printf 'jj-exec: changes preserved in:\n' >&2
            jj log --repository "$WORKTREE" --color always --limit 1 -r @ >&2
          fi

          if [[ -z "$BASE_COMMIT" ]]; then
            rm -rf "$WORKTREE"
          elif ! jj-workspace remove "$WORKTREE"; then
            printf 'jj-exec: kept %s\n' "$WORKTREE" >&2
          fi
          exit $exit_code
        }

        trap cleanup EXIT

        jj-workspace add "$WORKTREE" "$REVISION"
        BASE_COMMIT=$(jj log --repository "$WORKTREE" -r @- --no-graph --template commit_id)

        (cd "$WORKTREE" && "$@")
      '';
    })
  ];
}
