{ pkgs, ... }:
let
  #   curl -s 'https://api.fontshare.com/v2/fonts?limit=200' | jq -r \
  #     '.fonts[] | select(.slug=="NAME").styles[] | select(.is_variable).file
  #      | ltrimstr("//cdn.fontshare.com/wf/")'
  fetchFontShare =
    {
      name,
      file,
      hash,
    }:
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
      monospace = [ "Ioskeley Mono" ];
      sansSerif = [ "Inter" ];
      serif = [ "Liberation Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };

  };
  home.packages = [
    (fetchFontShare {
      name = "clash-grotesk";
      file = "5TRO2J3HJNIQODLQ4CTSMGSLAWSE5YUY/GHXENXHZCDIOE5E73364PNNASRNO3JVW/GLZTRU2GIKPV5HYT3E6HDLWOXAWPNZDV";
      hash = "sha256-WIeh383/KlTNtH7wFlZW5zXmDVDmGCplXxKXjS8N0S0=";
    })
  ]
  ++ (with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
    ioskeley-mono.normal
    liberation_ttf
    mplus-outline-fonts.githubRelease
    ubuntu-classic
    noto-fonts
    noto-fonts-color-emoji
    inter
    literata
    helvetica-neue-lt-std
    roboto
    roboto-flex
  ]);
}
