{ pkgs, ... }:
let
  name = "rebecca";

  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "home-assistant";
    tag = "v2.1.3";
    hash = "sha256-+m6lWer9a4AwmTgckhSHOKd0Oo6x9N0jjza4/F0ye3E=";
  };

  # top-level variables apply to both modes; these win over catppuccin's
  overrides = {
    ha-font-family-body = ''"Ioskeley Mono", ui-monospace, monospace'';
    ha-font-family-code = "var(--ha-font-family-body)";

    ha-card-border-radius = "var(--ha-border-radius-sm)";
    ha-card-border-width = "1px";
    ha-card-border-color = "var(--catppuccin-surface1)";
    ha-card-box-shadow = "none";
    ha-tile-icon-border-radius = "var(--ha-border-radius-sm)";

    # one step darker than mocha's base/mantle
    modes.dark = {
      primary-background-color = "var(--catppuccin-crust)";
      secondary-background-color = "var(--catppuccin-crust)";
      card-background-color = "var(--catppuccin-mantle)";
    };
  };

  theme =
    pkgs.runCommand "home-assistant-theme-${name}"
      {
        nativeBuildInputs = [
          pkgs.catppuccin-whiskers
          pkgs.yq-go
        ];
        overrides = builtins.toJSON overrides;
        passAsFile = [ "overrides" ];
        passthru.isHomeAssistantTheme = true;
      }
      ''
        whiskers ${catppuccin}/home-assistant.tera --overrides '{"accent": "sky"}'
        mkdir -p $out/themes
        yq --prettyPrint '{"${name}": (.["Catppuccin Auto Latte Mocha Sky"] * load(env(overridesPath)))}' \
          themes/catppuccin-sky.yaml > $out/themes/${name}.yaml
      '';
in
{
  services.home-assistant = {
    themes = [ theme ];

    config.automation = [
      {
        alias = "Apply the ${name} theme";
        triggers = [
          {
            trigger = "homeassistant";
            event = "start";
          }
        ];
        actions = [
          {
            action = "frontend.set_theme";
            data = {
              inherit name;
              name_dark = name;
            };
          }
        ];
      }
    ];
  };
}
