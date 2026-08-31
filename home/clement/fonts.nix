{ lib, pkgs, ... }:
let
  iosevka-mayukai =
    let
      builder =
        {
          name,
          hash,
          type ? "Editor",
        }:
        (pkgs.stdenvNoCC.mkDerivation rec {
          pname = "iosevka-mayukai-${lib.toLower name}-${lib.toLower type}";
          version = "6.2.0";

          src = pkgs.fetchzip (
            let
              v = lib.versions;
              file = "IosevkaMayukai${name}${type}-v${v.major version}${v.minor version}${v.patch version}.zip";
            in
            {
              url = "https://github.com/Iosevka-Mayukai/Iosevka-Mayukai/releases/download/v${version}/${file}";
              inherit hash;
            }
          );

          dontPatch = true;
          dontConfigure = true;
          dontBuild = true;
          doCheck = false;
          dontFixup = true;

          installPhase = ''
            runHook preInstall
            install -Dm644 -t $out/share/fonts/truetype/ TTF/*.ttf
            runHook postInstall
          '';
        });
    in
    {
      monolite = builder {
        name = "Monolite";
        hash = "sha256-4gqmpeIdwX6wQrRZr+THiaCeECL1tDvN4n9dThwWdCE=";
      };
    };

  #   curl -s 'https://api.fontshare.com/v2/fonts?limit=200' | jq -r \
  #     '.fonts[] | select(.slug=="NAME").styles[] | select(.is_variable).file
  #      | ltrimstr("//cdn.fontshare.com/wf/")'
  fetchFontShare =
    { name, file, hash }:
    pkgs.stdenvNoCC.mkDerivation {
      inherit name;

      src = pkgs.fetchurl {
        url = "https://cdn.fontshare.com/wf/${file}.ttf";
        inherit hash;
      };

      dontUnpack = true;

      installPhase = ''
        runHook preInstall
        install -Dm644 $src $out/share/fonts/truetype/${name}.ttf
        runHook postInstall
      '';
    };

in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "Inter" ];
      serif = [ "Liberation Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };

  };
  home.packages = [
    iosevka-mayukai.monolite
    (fetchFontShare {
      name = "clash-grotesk";
      file = "5TRO2J3HJNIQODLQ4CTSMGSLAWSE5YUY/GHXENXHZCDIOE5E73364PNNASRNO3JVW/GLZTRU2GIKPV5HYT3E6HDLWOXAWPNZDV";
      hash = "sha256-WIeh383/KlTNtH7wFlZW5zXmDVDmGCplXxKXjS8N0S0=";
    })
  ]
  ++ (with pkgs; [
    monaspace
    iosevka-bin
    iosevka-comfy.comfy
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts._0xproto
    nerd-fonts.iosevka
    liberation_ttf
    mplus-outline-fonts.githubRelease
    ubuntu-classic
    noto-fonts
    noto-fonts-color-emoji
    inter
    helvetica-neue-lt-std
    roboto
    roboto-flex
  ]);
}
