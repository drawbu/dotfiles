{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./atuin.nix
    ./bash.nix
    ./scripts
    ./zsh.nix
  ];

  home = {
    sessionVariables = {
      THEMEFILE = "${config.home.homeDirectory}/.currenttheme";
    }
    // (lib.optionalAttrs config.mod.profiles.desktop.enable {
      EDITOR = "nvim";
    });

    shellAliases = {
      lz = "lazygit";
      ufda = "test -z \"$(grep 'use flake' .envrc)\" && (echo 'use flake' >> .envrc); direnv allow";
      tree = "ls --tree -a";
      zed = "zeditor";
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      open = "xdg-open";
      arch = "distrobox enter arch";
      fedora = "distrobox enter fedora";
      macos = "nix run github:matthewcroughan/NixThePlanet#macos-ventura";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      x86 = "env /usr/bin/arch -x86_64 /bin/zsh --login";
      arm = "env /usr/bin/arch -arm64 /bin/zsh --login";
    };

  };

  programs = {
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [ "--group-directories-first" ];
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "Host *" = lib.optionalAttrs config.mod.onepassword.enable {
          IdentityAgent = config.mod.onepassword.agent;
        };
      };
    };
  };
}
