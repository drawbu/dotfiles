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

  # a long-lived access token from the HA profile page
  programs.onepassword-secrets.secrets.homeAssistantMcpToken = {
    path = ".config/mcp/home-assistant-token";
    reference = "op://nixos/mcp/home-assistant";
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

    # bridges stdio to HA's streamable HTTP endpoint, so the token stays in a
    # file instead of a client-specific header syntax
    servers.home-assistant = {
      command = lib.getExe pkgs.mcp-proxy;
      args = [
        "--transport=streamablehttp"
        "https://home-assistant.drawbu.dev/api/mcp"
      ];
      env.API_ACCESS_TOKEN.file = config.programs.onepassword-secrets.secretPaths.homeAssistantMcpToken;
    };
  };
}
