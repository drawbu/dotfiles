{ pkgs, config, ... }:
{
  home = {
    file = {
      ".config/AGENTS.md".source = ./AGENTS.md;
      ".claude/CLAUDE.md".source = ./AGENTS.md;
      ".config/opencode/AGENTS.md".source = ./AGENTS.md;
      ".gemini/GEMINI.md".source = ./AGENTS.md;
      ".vibe/AGENTS.md".source = ./AGENTS.md;
      ".codex/AGENTS.md".source = ./AGENTS.md;
      ".config/amp/AGENTS.md".source = ./AGENTS.md;
      ".pi/agent/AGENTS.md".source = ./AGENTS.md;

      ".claude/settings.json".source = ./settings.json;
      ".claude/session-context.sh".source = ./session-context.sh;
      ".config/opencode/opencode.json".text = builtins.toJSON {
        autoupdate = false;
        formatter = true;
        lsp = true;
        permission.bash = "ask";
      };
      ".vibe/config.toml".text = ''
        enable_auto_update = false
        skill_paths = [ "~/.agents/skills" ]
      '';

      ".agents/skills" = {
        source = ./skills;
        recursive = true;
      };
      ".claude/skills".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.agents/skills";
    };

    packages = with pkgs.unstable; [
      skills

      # clankers
      opencode
      amp-cli
      gemini-cli
      claude-code
      github-copilot-cli
      codex
      pi-coding-agent

      (stdenv.mkDerivation (finalAttrs: {
        pname = "umans";
        version = "0.1.42";
        src = fetchurl {
          url = "https://api.code.umans.ai/cli/umans";
          hash = "sha256-wfC8c+NjTa8GdEre4e1Je9A7fSfLzeoDIXBQoI91S5k=";
        };
        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          install -m 755 $src $out/bin/umans
          substituteInPlace $out/bin/umans \
            --replace-fail "#!/usr/bin/env python3" "#!${python3.interpreter}"
          runHook postInstall
        '';

        nativeInstallCheckInputs = [
          versionCheckHook
          writableTmpDirAsHomeHook
        ];
        versionCheckProgramArg = "version";
        versionCheckKeepEnvironment = "HOME";
        doInstallCheck = true;
      }))
    ];
  };

  # TODO: skills in ~/.agents/skills
}
