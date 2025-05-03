{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./bash.nix
    ./zsh.nix
    ./scripts
  ];

  home = {
    sessionVariables = {
      # Defaults
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "ghostty";

      THEMEFILE = "${config.home.homeDirectory}/.currenttheme";
    };

    shellAliases =
      {
        lz = "lazygit";
        portainer = "docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest";
        t = "tmux new-session -s";
        epidock = "docker run -it --rm -v \$(pwd):/home/project -w /home/project epitechcontent/epitest-docker:latest /bin/bash";
        "'??'" = "gh copilot suggest -t shell";
        "'git?'" = "gh copilot suggest -t git";
        please = "sudo";
        senpai = "sudo";
        ufda = "test -z \"$(grep 'use flake' .envrc)\" && (echo 'use flake' >> .envrc); direnv allow";
        tree = "ls --tree";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        arch = "distrobox enter arch";
        fedora = "distrobox enter fedora";
        macos = "nix run github:matthewcroughan/NixThePlanet#macos-ventura";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isMacOS {
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
      extraConfig = ''
        IdentityAgent "${
          if pkgs.stdenv.isDarwin then
            "~/Library/Group Containers/2BUA8C4S2C.com.1password/t"
          else
            "~/.1password"
        }/agent.sock"
        SetEnv TERM=xterm-256color
      '';
    };
  };
}
