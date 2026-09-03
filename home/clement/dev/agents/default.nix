{ pkgs, ... }:
{
  imports = [
    ./claude.nix
    ./opencode.nix
  ];

  home = {
    file = {
      ".config/AGENTS.md".source = ./AGENTS.md;
      ".gemini/GEMINI.md".source = ./AGENTS.md;
      ".codex/AGENTS.md".source = ./AGENTS.md;
      ".config/amp/AGENTS.md".source = ./AGENTS.md;
      ".pi/agent/AGENTS.md".source = ./AGENTS.md;

      ".agents/skills" = {
        source = ./skills;
        recursive = true;
      };
    };

    packages = with pkgs.unstable; [
      skills

      # clankers
      amp-cli
      antigravity-cli
      codex
      pi-coding-agent
    ];
  };
}
