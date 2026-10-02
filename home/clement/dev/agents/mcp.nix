{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.onepassword-secrets.secrets.githubMcpToken = {
    path = ".config/mcp/github-token";
    reference = "op://nixos/mcp/github";
  };

  programs.mcp = {
    enable = true;

    servers.github = {
      command = lib.getExe' pkgs.unstable.github-mcp-server "github-mcp-server";
      args = [
        "stdio"
        "--read-only"
        "--lockdown-mode"
      ];
      env.GITHUB_PERSONAL_ACCESS_TOKEN.file =
        config.programs.onepassword-secrets.secretPaths.githubMcpToken;
    };
  };
}
