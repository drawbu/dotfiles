{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.unstable.opencode-desktop ];

  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;

    context = ./AGENTS.md;

    settings = {
      model = "openrouter/gpt-5.6-terra";
      small_model = "openrouter/gpt-5.6-luna";

      shell = lib.getExe config.programs.zsh.package;

      share = "disabled";

      lsp = true;

      enabled_providers = [
        "openai"
        "openrouter"
        "opencode"
      ];

      permission = {
        bash = {
          "*" = "allow";
          "apt *" = "deny";
          "apt-cache *" = "deny";
          "dnf *" = "deny";
          "gh *" = "deny";
          "git pull *" = "deny";
          "git push *" = "deny";
          "jj git fetch *" = "deny";
          "jj git push *" = "deny";
          "nix env *" = "deny";
          "nix-env *" = "deny";
        };

        read = {
          "./.env" = "deny";
          "./secrets/**" = "deny";
        };

        edit = "allow";

        external_directory = {
          "~/secrets/**" = "deny";
          "*" = "allow";
        };
      };
    };
  };

  # mirrors claude-code features missing
  home.file.".config/opencode/plugins/agent.ts".text = ''
    import type { Plugin } from "@opencode-ai/plugin"

    export const Agent: Plugin = async ({ $ }) => {
      const contextBySession = new Map<string, string>()

      return {
        "shell.env": async (_input, output) => {
          output.env.GIT_SSH_COMMAND = "${lib.getExe pkgs.openssh} -o IdentityAgent=none"
          output.env._ZO_DOCTOR = "0"
        },

        "tool.execute.after": async (input) => {
          if (["write", "edit", "multiedit"].includes(input.tool)) {
            await $`jj root >/dev/null 2>&1 && jj util snapshot --quiet`.quiet().nothrow()
          }
        },

        "experimental.chat.system.transform": async (input, output) => {
          if (!input.sessionID) return
          let context = contextBySession.get(input.sessionID)
          if (context === undefined) {
            context = await $`${./session-context.sh}`.quiet().nothrow().text()
            contextBySession.set(input.sessionID, context)
          }
          output.system.push(context)
        },
      }
    }
  '';
}
