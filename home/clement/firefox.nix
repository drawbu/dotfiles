{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;
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
