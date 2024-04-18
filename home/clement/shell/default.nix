{pkgs, ...}: {
  imports = [
    ./bash.nix
    ./zsh.nix
    ./scripts.nix
  ];

  home = {
    sessionVariables = {
      # Defaults
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";

      THEMEFILE = "$HOME/.currenttheme";
    };

    file = {
      ".config/starship.toml".source = ./starship.toml;

      ".shell-extra".text = ''
        export PATH="$HOME/.local/bin:$PATH"

        # WakaTime
        export ZSH_WAKATIME_PROJECT_DETECTION=true

        # Rust
        export CARGO_NET_GIT_FETCH_WITH_CLI=true
        export PATH="$HOME/.cargo/bin:$PATH"

        if [ -f "$THEMEFILE" ] && [ "$CURRENT_TERMINAL" = "kitty" ]; then
          theme=$(cat "$THEMEFILE")
          ${pkgs.kitty}/bin/kitty @ set-colors -a "$XDG_CONFIG_HOME/kitty/$theme.conf"
        fi
      '';
    };

    shellAliases = {
      lz = "lazygit";
      portainer = "docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest";
      v = "nvim .";
      t = "tmux new-session \\; split-window -h";
      epidock = "docker run -it --rm -v \$(pwd):/home/project -w /home/project epitechcontent/epitest-docker:latest /bin/bash";
      vi = "${pkgs.vim}/bin/vim";
      "'??'" = "gh copilot suggest -t shell";
      "'git?'" = "gh copilot suggest -t git";
      arch = "distrobox enter arch";
      fedora = "distrobox enter fedora";
    };
  };

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
