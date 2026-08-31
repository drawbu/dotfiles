{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;
    context = ./AGENTS.md;

    settings = {
      model = "opus";
      effortLevel = "high";
      outputStyle = "Concise";
      theme = "auto";
      tui = "fullscreen";

      autoMemoryEnabled = false;
      awaySummaryEnabled = false;
      skipAutoPermissionPrompt = true;
      disableClaudeAiConnectors = true;
      disableArtifact = true;

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
