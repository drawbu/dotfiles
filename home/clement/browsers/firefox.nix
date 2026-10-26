{ config, lib, ... }:
{
  programs.firefox = {
    enable = lib.mkDefault config.mod.profiles.desktop.enable;
    languagePacks = [
      "en-US"
      "fr-FR"
    ];

    profiles."clement" = {
      settings = {
        "middlemouse.paste" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
      };
    };
  };
}
