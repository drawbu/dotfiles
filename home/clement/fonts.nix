{ pkgs, ... }:
let
  monolisa = pkgs.stdenvNoCC.mkDerivation {
    pname = "monolisa";
    version = "2.0";

    src = pkgs.fetchFromGitHub {
      owner = "kashfr";
      repo = "monolisa";
      rev = "9c5f4fb33a0005049e091d623f19b73f1e0f46cd";
      hash = "sha256-pY9yOD+7IwFyS1JfUV/utY5aDtkK4tTlw7EnDYz9Q6s=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    doCheck = false;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      install -Dm644 -t $out/share/fonts/truetype/ fonts/*.ttf
      runHook postInstall
    '';
  };
in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "Helvetica Neue" ];
      serif = [ "Liberation Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };

  };
  home.packages =
    [ monolisa ]
    ++ (with pkgs; [
      monaspace
      iosevka-bin
      iosevka-comfy.comfy
      jetbrains-mono
      nerdfonts
      liberation_ttf
      mplus-outline-fonts.githubRelease
      ubuntu_font_family
      noto-fonts
      noto-fonts-color-emoji
      inter
      helvetica-neue-lt-std
    ]);
}
