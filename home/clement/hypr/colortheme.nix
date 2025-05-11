{ pkgs, ... }:
let
  createCSS =
    theme:
    let
      colors = import ./colors.nix { inherit theme; };
      generateCssString =
        attrs:
        let
          transformedAttrs = builtins.mapAttrs (name: value: "${value.css}: ${value.hex};") attrs;
        in
        builtins.concatStringsSep "\n  " (builtins.attrValues transformedAttrs);
    in
    # css
    ''
      * {
        --foreground: ${colors.foreground.hex};
        --background: ${colors.background.hex};
        --darker: ${colors.darker.hex};
        --accent: ${colors.accent.hex};

        --cursorColor: ${colors.accent.hex};
        --comment: ${colors.comment.hex};

        /* Generated */
        ${generateCssString colors.raw}
      };
    '';

  activation = import ./symlink.nix {
    inherit pkgs;
    path = "$HOME";
    file = "theme.css";
    default = "dark.css";
  };
in
{
  home = {
    file = {
      "dark.css".text = createCSS "dark";
      "light.css".text = createCSS "light";
    };
    activation.createCSSTheme = "sh ${activation.script}";
  };
}
