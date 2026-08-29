{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mod.profiles.desktop.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.unstable.zed-editor;

      extensions = [
        "astro"
        "catppuccin"
        "catppuccin-blur"
        "catppuccin-icons"
        "dockerfile"
        "git-firefly"
        "html"
        "kdl"
        "latex"
        "lua"
        "make"
        "neocmake"
        "nix"
        "oxc"
        "postgres-language-server"
        "prisma"
        "scss"
        "sql"
        "svelte"
        "templ"
        "toml"
        "typst"
        "vue"
        "wakatime"
        "zig"
      ];

      userSettings = {
        auto_update = false;
        disable_ai = true;
        telemetry.diagnostics = false;

        vim_mode = true;
        confirm_quit = true;
        autosave = "on_focus_change";
        cli_default_open_behavior = "existing_window";
        diff_view_style = "unified";

        theme = {
          mode = "system";
          light = "Catppuccin Latte";
          dark = "Catppuccin Mocha";
        };
        icon_theme = "Catppuccin Latte";
        ui_font_family = "JetBrains Mono";
        ui_font_size = 16;
        buffer_font_family = "JetBrains Mono";
        buffer_font_size = 16;

        preferred_line_length = 80;
        soft_wrap = "editor_width";
        allow_rewrap = "in_selections";
        wrap_guides = [
          80
          120
        ];

        project_panel.dock = "left";
        outline_panel.dock = "left";
        collaboration_panel.dock = "left";
        git_panel.dock = "left";
        tabs.git_status = true;
        diagnostics.inline.enabled = true;
        calls.mute_on_join = true;
        git = {
          blame.show_avatar = true;
          # inline_blame.show_commit_summary = true;
        };

        edit_predictions = {
          mode = "subtle";
          enabled_in_text_threads = false;
        };

        languages = {
          Nix.language_servers = [
            "nixd"
            "!nil"
          ];
          # basedpyright is too based for me
          Python.language_servers = [
            "ty"
            "!basedpyright"
            "!pyright"
          ];
          SQL.language_servers = [
            "squawk --config backend/reflog-database/migrations/.squawk.toml server"
            # "!pg"
          ];
          Zig.show_edit_predictions = false;
          Typst.allow_rewrap = "anywhere";
          LaTeX.allow_rewrap = "anywhere";
        };

        lsp = {
          vtsls = {
            enable_lsp_tasks = true;
            settings = {
              typescript.updateImportsOnFileMove.enabled = "always";
              javascript.updateImportsOnFileMove.enabled = "always";
            };
          };
          rust-analyzer.initialization_options.cargo.targetDir = true;
        };
      };

      userKeymaps =
        let
          esc = builtins.fromJSON "\"\\u001b\"";
        in
        [
          {
            context = "Terminal";
            bindings."shift-enter" = [
              "terminal::SendText"
              "${esc}\r"
            ];
          }
        ];
    };
  };
}
