{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "jj-exec";
      runtimeInputs = [ config.programs.jujutsu.package ];
      text = ''
        usage() {
          printf 'Usage: jj exec [-r <rev>] [--] <cmd> [<args>...]\n' >&2
          printf '\nRun <cmd> in a temporary jj workspace.\n' >&2
          printf '  -r <rev>   Parent revision for the workspace (default: @)\n' >&2
          exit 1
        }

        REPO_ROOT=$(jj root)

        REVISION='@'
        if ! jj diff --repository "$REPO_ROOT" -r "$REVISION" --summary 2>/dev/null | grep -q .; then
          REVISION='@-'
        fi

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
        WORKSPACE_ID=$(basename "$WORKTREE")
        BASE_COMMIT=""

        cleanup() {
          local exit_code=$?
          set +e

          local top_change_id has_changes
          top_change_id=$(jj log --repository "$WORKTREE" -r @ \
            --no-graph --template "change_id" 2>/dev/null)

          if [[ -n "$top_change_id" && -n "$BASE_COMMIT" ]]; then
            has_changes=$(jj diff --repository "$WORKTREE" --from "$BASE_COMMIT" \
              --summary 2>/dev/null)

            if [[ -n "$has_changes" ]]; then
              printf 'jj-exec: changes preserved in:\n' >&2
              jj log --repository "$REPO_ROOT" --color always --limit 1 \
                -r "$top_change_id" >&2
            else
              jj abandon --repository "$REPO_ROOT" "$top_change_id" >/dev/null 2>&1
            fi
          fi

          jj workspace forget --repository "$REPO_ROOT" "$WORKSPACE_ID" >/dev/null 2>&1
          rm -rf "$WORKTREE"
          exit $exit_code
        }

        trap cleanup EXIT

        jj workspace add \
          --repository "$REPO_ROOT" \
          --name "$WORKSPACE_ID" \
          --revision "$REVISION" \
          "$WORKTREE" >/dev/null

        BASE_COMMIT=$(jj log --repository "$REPO_ROOT" -r "$REVISION" \
          --no-graph --template "commit_id")

        for dir in .claude local; do
          [[ -e "$REPO_ROOT/$dir" ]] && ln -s "$REPO_ROOT/$dir" "$WORKTREE/$dir"
        done

        (cd "$WORKTREE" && "$@")
      '';
    })
  ];
}
