{ ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
      version = "1";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
}
