{ pkgs, config, ... }:
{
  home = {
    file = {
      ".config/AGENTS.md".source = ./AGENTS.md;
      ".claude/CLAUDE.md".source = ./AGENTS.md;
      ".gemini/GEMINI.md".source = ./AGENTS.md;
      ".codex/AGENTS.md".source = ./AGENTS.md;
      ".config/amp/AGENTS.md".source = ./AGENTS.md;
      ".pi/agent/AGENTS.md".source = ./AGENTS.md;

      ".claude/settings.json".source = ./settings.json;
      ".claude/session-context.sh".source = ./session-context.sh;
      ".claude/statusline.sh".source = ./statusline.sh;

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
      amp-cli
      antigravity-cli
      claude-code
      codex
      pi-coding-agent
    ];
  };

  # TODO: skills in ~/.agents/skills
}
