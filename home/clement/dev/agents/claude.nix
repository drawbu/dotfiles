{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    context = ./AGENTS.md;

    settings = {
      model = "opus";
      tui = "fullscreen";

      env._ZO_DOCTOR = "0";

      voice = {
        enabled = true;
        mode = "tap";
      };

      enabledPlugins = lib.genAttrs (map (name: "${name}@claude-plugins-official") [
        "clangd-lsp"
        "gopls-lsp"
        "pyright-lsp"
        "rust-analyzer-lsp"
        "typescript-lsp"
      ]) (_: true);

      statusLine = {
        type = "command";
        command = "${./statusline.sh}";
      };

      hooks = {
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "${./session-context.sh}";
              }
            ];
          }
        ];
        PostToolUse = [
          {
            matcher = "Edit|Write|MultiEdit";
            hooks = [
              {
                type = "command";
                command = "jj root >/dev/null 2>&1 && jj util snapshot --quiet";
              }
            ];
          }
        ];
      };

      permissions = {
        defaultMode = "auto";

        allow =
          map (cmd: "Bash(${cmd})") [
            "GIT_CONFIG_GLOBAL=/dev/null git clone *"
            "agent-browser *"
            "cargo +nightly fmt *"
            "cargo add *"
            "cargo build *"
            "cargo check *"
            "cargo clippy *"
            "cargo doc *"
            "cargo nextest *"
            "cargo search *"
            "cargo tree *"
            "file *"
            "git diff *"
            "git ls-remote *"
            "git ls-tree *"
            "git show *"
            "go doc *"
            "grep *"
            "hydra-check *"
            "jj diff *"
            "jj file list *"
            "jj file show *"
            "jj file track *"
            "jj file untrack *"
            "jj help *"
            "jj log *"
            "jj op log *"
            "jj resolve --list"
            "jj show *"
            "jj st *"
            "jj status *"
            "ls *"
            "make *"
            "nix build *"
            "nix derivation show *"
            "nix log *"
            "nix search *"
            "nix-build *"
            "nm *"
            "npm --version"
            "pdftotext *"
            "pnpm --version"
            "pnpm add *"
            "pnpm audit *"
            "pnpm exec eslint *"
            "pnpm exec prettier *"
            "pnpm exec slidev *"
            "pnpm exec tsc *"
            "pnpm info *"
            "pnpm install"
            "pnpm link *"
            "pnpm list *"
            "pnpm remove *"
            "pnpm run build *"
            "pnpm run check *"
            "pnpm run format *"
            "pnpm run format:check *"
            "pnpm run lint *"
            "pnpm run lint:check *"
            "pnpm run postinstall"
            "pnpm unlink *"
            "pnpm view *"
            "pnpm why *"
            "pnpx @tanstack/intent@latest list"
            "pnpx @tanstack/intent@latest load *"
            "podman inspect *"
            "tar *"
            "typst compile *"
            "unar *"
            "unzip *"
            "zip *"
            "~/.agents/skills/node-dep-source/clone-dep.ts *"
            "~/.claude/skills/node-dep-source/clone-dep.ts *"
          ]
          ++ map (path: "Read(${path})") [
            "./local/**"
            "//nix/store/**"
            "//tmp/**"
            "//tmp/claude-deps/**"
            "~/.cargo/**"
            "~/.claude/skills/**"
            "~/.config/AGENTS.md"
            "~/Developer/dotfiles/**"
            "~/Developer/nixpkgs/**"
          ]
          ++ map (domain: "WebFetch(domain:${domain})") [
            "api.anthropic.com"
            "api.github.com"
            "aur.archlinux.org"
            "codeberg.org"
            "developers.cloudflare.com"
            "discourse.nixos.org"
            "docs.jj-vcs.dev"
            "gcc.gnu.org"
            "gist.github.com"
            "github.com"
            "gitlab.archlinux.org"
            "gitweb.gentoo.org"
            "hydra.nixos.org"
            "jj-vcs.github.io"
            "man.archlinux.org"
            "npmjs.com"
            "npmx.dev"
            "oxc.rs"
            "raw.githubusercontent.com"
            "sources.debian.org"
            "src.fedoraproject.org"
          ]
          ++ map (tool: "mcp__github__${tool}") [
            "get_commit"
            "get_file_contents"
            "issue_read"
            "list_commits"
            "list_issues"
            "list_pull_requests"
            "pull_request_read"
            "search_code"
            "search_issues"
            "search_pull_requests"
          ]
          ++ map (name: "Skill(${name})") [
            "node-dep-source"
            "typst"
          ]
          ++ [ "WebSearch" ];

        deny =
          map (cmd: "Bash(${cmd})") [
            "apt *"
            "apt-cache *"
            "dnf *"
            "gh *"
            "git pull *"
            "git push *"
            "jj git fetch *"
            "jj git push *"
            "nix env *"
            "nix-env *"
            "pnpm approve-builds"
          ]
          ++ map (path: "Read(${path})") [
            "./.env"
            "./secrets/**"
          ];
      };
    };
  };

  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills";
}
