{ ... }:
{
  programs.firefox = {
    enable = true;

    profiles."clement" = {
      settings = {
        "middlemouse.paste" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
      };
    };
  };
}
