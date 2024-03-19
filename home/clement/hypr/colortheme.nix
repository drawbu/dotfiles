{pkgs, ...}: let
  createCSS = theme: let
    colors = import ./colors.nix {inherit theme;};
    generateCssString = attrs: let
      transformedAttrs = builtins.mapAttrs (name: value: "${value.css}: ${value.hex};") attrs;
    in
      builtins.concatStringsSep "\n  " (builtins.attrValues transformedAttrs);
  in ''
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

  activation = pkgs.writeShellScript "activation" ''
    path="$HOME"
    file="$path/theme.css"

    [ -f $file ] || ln -s "$path/dark.css" $file
  '';
in {
  home = {
    file = {
      "dark.css".text = createCSS "dark";
      "light.css".text = createCSS "light";
    };
    activation.createCSSTheme = "sh ${activation}";
  };
}
