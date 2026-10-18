{ ... }:
let
  work = {
    email = "cboillot@advanced-schema.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0J6XUw6LIBI0TlW++l3oe9sn33DcRpZdrUJ7QPclYw";
  };
in
{
  imports = [
    ../../nixos/base.nix
    ../../nixos/users/clement.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "faraday";
  system.stateVersion = "26.05";

  wsl = {
    enable = true;
    defaultUser = "clement";
    ssh-agent.enable = true;
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  users.users.clement.extraGroups = [
    "docker"
    "podman"
  ];

  services.tailscale.enable = true;

  environment.sessionVariables = {
    GALLIUM_DRIVER = "d3d12";
    LD_LIBRARY_PATH = [ "/usr/lib/wsl/lib" ];
  };

  home-manager.users.clement =
    {
      config,
      osConfig,
      pkgs,
      lib,
      ...
    }:
    {
      home.stateVersion = osConfig.system.stateVersion;

      home.packages = with pkgs; [
        (lib.hiPrio nodejs_22)
        kcat
        dbeaver-bin
        # unstable.bruno
        unstable.bruno-cli
        wsl-open
        xdg-utils
      ];

      mod.onepassword = {
        enable = true;
        signer = "op-ssh-sign.exe";
        agent = "\${XDG_RUNTIME_DIR}/wsl2-ssh-agent.sock";
      };

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
      programs.zed-editor.enable = true;
      programs.zathura.enable = true;
      programs.obsidian.enable = true;

      xdg.enable = true;
      xdg.desktopEntries.wsl-open = {
        name = "Windows default application";
        exec = "wsl-open %u";
        noDisplay = true;
      };
      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          lib.genAttrs [
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ] (_: "wsl-open.desktop")
          // {
            "x-scheme-handler/bruno" = "bruno.desktop";
          };
      };
    };
}
