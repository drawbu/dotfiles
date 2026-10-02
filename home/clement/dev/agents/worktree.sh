# WorktreeCreate and WorktreeRemove hook: back Claude Code worktrees with jj
# workspaces, or with git worktrees outside jj repositories.
# Usage: worktree create|remove, with the hook input on stdin.

input=$(cat)
field() { jq -r ".$1 // empty" <<<"$input"; }

case "${1:-}" in
create)
    cd "$(field cwd)"
    # Outside the repository: Claude Code refuses a worktree that git resolves
    # to the outer checkout. The basename names the jj workspace, and must be
    # unique in the repository.
    session=$(field session_id)
    name=$(field name)
    path="${XDG_CACHE_HOME:-$HOME/.cache}/claude-worktrees/${session:0:8}-${name//\//-}"
    if jj root &>/dev/null; then
        jj-workspace add "$path" >&2
    else
        git worktree add --detach "$path" >&2
    fi
    printf '%s\n' "$path"
    ;;
remove)
    # Claude Code keeps the directory when this fails.
    path=$(field worktree_path)
    if jj root --repository "$path" &>/dev/null; then
        jj-workspace remove "$path"
    else
        git -C "$path" worktree remove "$path"
    fi
    ;;
*)
    printf 'usage: worktree create|remove\n' >&2
    exit 1
    ;;
esac
