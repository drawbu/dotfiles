{ config, lib, ... }:
{
  programs.obsidian = {
    enable = lib.mkDefault config.mod.profiles.desktop.enable;
    vaults.notes.settings = {
      app = {
        vimMode = true;
        livePreview = false;
        useMarkdownLinks = true;
        newLinkFormat = "relative";
        alwaysUpdateLinks = true;
        newFileLocation = "folder";
        newFileFolderPath = "inbox";
        attachmentFolderPath = "attachments";
        userIgnoreFilters = [ "attachments/" ];
      };
      appearance = {
        theme = "system";
        accentColor = "#3b82f6";
        showRibbon = false;
        showViewHeader = false;
        textFontFamily = "Literata";
        interfaceFontFamily = "Literata";
        monospaceFontFamily = "Ioskeley Mono";
      };
      corePlugins = [
        "backlink"
        "bases"
        "command-palette"
        {
          name = "daily-notes";
          settings = {
            folder = "journal";
            format = "YYYY-MM-DD-ddd";
          };
        }
        "file-explorer"
        "file-recovery"
        "global-search"
        "outline"
        "switcher"
      ];
      hotkeys.daily-notes = [
        {
          modifiers = [
            "Mod"
            "Shift"
          ];
          key = "D";
        }
      ];
      communityPlugins = [ ];
      cssSnippets = [
        {
          name = "hide-files";
          text = ''
            .nav-folder-title[data-path="attachments"] {
              display: none;
            }
          '';
        }
        {
          name = "deep-dark";
          text = ''
            .theme-dark {
              --color-base-00: #0d0d0d;
              --color-base-05: #101010;
              --color-base-10: #121212;
              --color-base-20: #151515;
              --color-base-25: #191919;
              --color-base-30: #222222;
              --color-base-35: #2a2a2a;
            }
          '';
        }
      ];
    };
  };
}
