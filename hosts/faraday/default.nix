{ ... }:
let
  work = {
    email = "cboillot@advanced-schema.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0J6XUw6LIBI0TlW++l3oe9sn33DcRpZdrUJ7QPclYw";
  };
in
{
  imports = [
    ../../nixos
    ../../nixos/users/clement.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "faraday";
  system.stateVersion = "26.05";

  home-manager.users.clement =
    {
      config,
      osConfig,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ ../../home/clement/linux.nix ];
      home.stateVersion = osConfig.system.stateVersion;

      home.packages = with pkgs; [
        (lib.hiPrio nodejs_22)
        kcat
        dbeaver-bin
        # unstable.bruno
        unstable.bruno-cli
      ];

      programs.git.includes = [
        {
          condition = "gitdir:~/work/";
          contents.user = { inherit (work) email signingKey; };
        }
      ];

      programs.jujutsu.settings."--scope" = [
        {
          "--when".repositories = [ "~/work" ];
          user = { inherit (work) email; };
          signing.key = work.signingKey;
        }
      ];

      programs.nh.flake = "${config.home.homeDirectory}/perso/dotfiles";
    };

  # services.xserver.xkb.layout = "fr";

  zramSwap.enable = true;
}
