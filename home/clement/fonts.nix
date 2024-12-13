{ pkgs, ... }:
let
  inherit (pkgs) lib;
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

          src = pkgs.fetchzip (let
            v = lib.versions;
            file = "IosevkaMayukai${name}${type}-v${v.major version}${v.minor version}${v.patch version}.zip";
          in {
            url = "https://github.com/Iosevka-Mayukai/Iosevka-Mayukai/releases/download/v${version}/${file}";
            inherit hash;
          });

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
  home.packages =
    [ iosevka-mayukai.monolite ]
    ++ (with pkgs; [
      monaspace
      iosevka-bin
      iosevka-comfy.comfy
      jetbrains-mono
      (nerdfonts.override {
        fonts = [
          "0xProto"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
      liberation_ttf
      mplus-outline-fonts.githubRelease
      ubuntu_font_family
      noto-fonts
      noto-fonts-color-emoji
      inter
      helvetica-neue-lt-std
    ]);
}
