{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./claude.nix
    ./mcp.nix
    ./opencode.nix
  ];

  programs.jujutsu.settings."--scope" = [
    {
      "--when".environments = [ "AGENT" ];
      ui = {
        editor = "true";
        diff-editor = "false";
        merge-editor = "false";
        paginate = "never";
      };
    }
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

    packages =
      with pkgs;
      [
        llm.skills
        llm.agent-browser
        extra.depsrc
        llm.herdr-core

        llm.amp
        llm.pi
      ]
      ++ lib.optionals config.mod.profiles.desktop.enable [
        llm.herdr-app
      ];
  };
}
