{ config, pkgs, ... }:
let
  jj-workspace = pkgs.writeShellApplication {
    name = "jj-workspace";
    runtimeInputs = [
      config.programs.jujutsu.package
      pkgs.rust-petname
    ];
    text = ''
      usage() {
        cat >&2 <<'EOF'
      Usage: jj w add [-r <rev>] [<name>]
             jj w remove <name|path>
             jj w exec [-r <rev>] [--] <cmd> [<args>...]
             jj w list [--color]

      Manage workspaces under <repo>/local/workspaces, named <hostname>-<name>.
        add      Create workspace <name> (default: generated) on <rev>
                 (default: @, or @- when @ has no changes), and print its path
        remove   Forget the workspace and delete its directory
        exec     Run <cmd> in a new exec-<generated> workspace, deleted when
                 <cmd> exits
        list     Print <name>\t<*: main>\t<path> for each local workspace,
                 with the current one in green
      EOF
        exit 1
      }

      main_root() {
        local root
        root=$(jj root)
        if [[ -f "$root/.jj/repo" ]]; then
          root=$(cd "$root/.jj" && cd "$(<repo)/../.." && pwd -P)
        fi
        printf '%s\n' "$root"
      }

      generate_name() {
        local prefix=''${1:-} workspaces name
        workspaces=$(main_root)/local/workspaces
        while name=$prefix$(petname --lists small) && [[ -e "$workspaces/$name" ]]; do :; done
        printf '%s\n' "$name"
      }

      cmd_add() {
        local revision=""
        if [[ "''${1:-}" == -r ]]; then
          [[ $# -ge 2 ]] || usage
          revision=$2
          shift 2
        fi
        [[ $# -le 1 ]] || usage

        local name=''${1:-} root main path
        [[ -n "$name" ]] || name=$(generate_name)
        root=$(jj root)
        main=$(main_root)
        path=$main/local/workspaces/$name

        if [[ -z "$revision" ]]; then
          revision='@'
          if [[ -z "$(jj diff -r @ --summary)" ]]; then
            revision='@-'
          fi
        fi

        local commit
        commit=$(jj log -r "$revision" --no-graph --template commit_id)

        mkdir -p "$(dirname "$path")"
        jj workspace add --quiet \
          --name "$HOSTNAME-$name" \
          --revision "$commit" \
          "$path" >/dev/null

        for dir in .claude local; do
          if [[ -e "$main/$dir" ]]; then
            ln -s "$main/$dir" "$path/$dir"
          fi
        done

        if [[ -d "$root/target" ]] &&
          ! cp -a --reflink=always "$root/target" "$path/target" 2>/dev/null; then
          printf 'jj-workspace: cannot reflink target/, starting cold\n' >&2
          rm -rf "$path/target"
        fi

        printf '%s\n' "$path"
      }

      cmd_remove() {
        [[ $# -eq 1 ]] || usage
        local path=$1
        if [[ "$path" != */* ]]; then
          path=$(main_root)/local/workspaces/$path
        fi
        if [[ ! -f "$path/.jj/repo" ]]; then
          printf 'jj-workspace: %s is not a secondary workspace\n' "$path" >&2
          return 1
        fi
        # Chained: the exec cleanup runs this with errexit off.
        jj workspace update-stale --quiet --repository "$path" &&
          jj util snapshot --quiet --repository "$path" &&
          jj workspace forget --quiet --repository "$path" &&
          rm -rf "$path"
      }

      cmd_exec() {
        local add_args=()
        if [[ "''${1:-}" == -r ]]; then
          [[ $# -ge 2 ]] || usage
          add_args=(-r "$2")
          shift 2
        fi
        [[ "''${1:-}" != -- ]] || shift
        [[ $# -ge 1 ]] || usage

        # Not local: the EXIT trap reads them after this function returns.
        path=$(cmd_add "''${add_args[@]}" "$(generate_name exec-)")
        base=$(jj log --repository "$path" -r @- --no-graph --template commit_id)

        cleanup() {
          local exit_code=$?
          trap "" INT
          set +e

          if [[ -n "$(jj diff --repository "$path" --from "$base" --summary 2>/dev/null)" ]]; then
            printf 'jj-workspace: changes preserved in:\n' >&2
            jj log --repository "$path" --color always --limit 1 -r @ >&2
          fi

          if ! cmd_remove "$path"; then
            printf 'jj-workspace: kept %s\n' "$path" >&2
          fi
          exit $exit_code
        }
        trap cleanup EXIT

        (cd "$path" && "$@")
      }

      cmd_list() {
        local color=""
        case "''${1:-}" in
          --color) color=1 ;;
          "") ;;
          *) usage ;;
        esac

        local current name root main
        current=$(jj root)
        jj workspace list --ignore-working-copy \
          -T 'if(self.root(), self.name() ++ "\t" ++ self.root() ++ "\n")' |
          while IFS=$'\t' read -r name root; do
            main=""
            [[ ! -d "$root/.jj/repo" ]] || main="*"
            if [[ -n "$color" && "$root" == "$current" ]]; then
              name=$'\e[1;32m'$name$'\e[0m'
            fi
            printf '%s\t%s\t%s\n' "$name" "$main" "$root"
          done
      }

      [[ $# -ge 1 ]] || usage
      command=$1
      shift
      case "$command" in
        add) cmd_add "$@" ;;
        remove) cmd_remove "$@" ;;
        exec) cmd_exec "$@" ;;
        list) cmd_list "$@" ;;
        *) usage ;;
      esac
    '';
  };
in
{
  home.packages = [ jj-workspace ];
}
