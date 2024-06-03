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

        if [ -f "$THEMEFILE" ] && [ "$CURRENT_TERMINAL" = "kitty" ]; then
          theme=$(cat "$THEMEFILE")
          ${pkgs.kitty}/bin/kitty @ set-colors -a "$XDG_CONFIG_HOME/kitty/$theme.conf"
        fi
      '';
    };

    shellAliases = {
      lz = "lazygit";
      portainer = "docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest";
      t = "tmux new-session -s";
      epidock = "docker run -it --rm -v \$(pwd):/home/project -w /home/project epitechcontent/epitest-docker:latest /bin/bash";
      "'??'" = "gh copilot suggest -t shell";
      "'git?'" = "gh copilot suggest -t git";
      arch = "distrobox enter arch";
      fedora = "distrobox enter fedora";
      macos = "nix run github:matthewcroughan/NixThePlanet#macos-ventura";
      please = "sudo";
      senpai = "sudo";
      ufda = "echo 'use flake' | tee .envrc";
    };
  };
}
