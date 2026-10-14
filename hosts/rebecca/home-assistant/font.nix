# Serves Ioskeley Mono to every browser, so the theme renders the same on
# devices that do not have it installed.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  family = "Ioskeley Mono";
  dir = "ioskeley";

  weights = {
    Light = 300;
    Regular = 400;
    Medium = 500;
    Bold = 700;
  };

  # Latin-1, Latin Extended-A, punctuation, arrows, box drawing and shapes
  unicodes = "U+0000-017F,U+2000-206F,U+20AC,U+2122,U+2190-21FF,U+2500-25FF";

  fontFace = style: weight: ''
    @font-face {
      font-family: "${family}";
      src: url("/local/${dir}/${style}.woff2") format("woff2");
      font-weight: ${toString weight};
      font-display: swap;
    }
  '';

  loader = pkgs.writeText "font.js" ''
    const style = document.createElement("style");
    style.textContent = ${builtins.toJSON (lib.concatStrings (lib.mapAttrsToList fontFace weights))};
    document.head.append(style);
  '';

  bundle =
    pkgs.runCommand "home-assistant-font-${dir}"
      {
        nativeBuildInputs = [
          (pkgs.python3.withPackages (p: [
            p.fonttools
            p.brotli
          ]))
        ];
      }
      ''
        mkdir $out
        cp ${loader} $out/font.js
        ${lib.concatMapStrings (style: ''
          pyftsubset ${pkgs.ioskeley-mono.normal}/share/fonts/truetype/IoskeleyMono-${style}.ttf \
            --unicodes=${unicodes} --layout-features='*' --flavor=woff2 \
            --output-file=$out/${style}.woff2
        '') (lib.attrNames weights)}
      '';

  www = "${config.services.home-assistant.configDir}/www";
in
{
  # HA only registers /local when www exists at startup
  systemd.tmpfiles.rules = [
    "d ${www} 0755 hass hass - -"
    "L+ ${www}/${dir} - - - - ${bundle}"
  ];

  services.home-assistant.config.frontend.extra_module_url = [
    "/local/${dir}/font.js?${builtins.substring 11 8 bundle.outPath}"
  ];
}
