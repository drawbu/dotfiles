{ pkgs, ... }:
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
  home.packages = with pkgs; [
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
  ];
}
