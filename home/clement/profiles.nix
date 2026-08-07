{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mod = {
    profiles = {
      desktop.enable = lib.mkEnableOption "desktop workstation profile";
      gaming.enable = lib.mkEnableOption "gaming profile";
    };

    onepassword = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.mod.profiles.desktop.enable;
        description = ''
          Whether the 1Password app runs on this host. It provides the ssh agent
          used to authenticate, and `op-ssh-sign` used to sign commits. Hosts
          without it fall back to whatever agent the environment provides (a
          forwarded one, typically) and do not sign.
        '';
      };

      signer = lib.mkOption {
        type = lib.types.str;
        default =
          if pkgs.stdenv.isDarwin then
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            lib.getExe' pkgs._1password-gui "op-ssh-sign";
        description = "Path to the 1Password ssh signing helper.";
      };

      agent = lib.mkOption {
        type = lib.types.str;
        default =
          if pkgs.stdenv.isDarwin then
            "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else
            "~/.1password/agent.sock";
        description = "Path to the 1Password ssh agent socket.";
      };
    };
  };
}
