{ pkgs, lib, ... }:
{
  imports = [
    ./waybar.nix
    ./hyprlock.nix
    ./colortheme.nix
  ];

  home = {
    packages = with pkgs; [
      extra.hyprqtile
      hyprpaper
      kdePackages.xwaylandvideobridge
      pyprland
      nwg-displays
      cliphist
      wl-clipboard
      kooha
    ];
  };

  services = {
    swayosd.enable = true;
    hypridle = {
      enable = true;
      settings = {

        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "${lib.getExe pkgs.brightnessctl} -s set 10";
            on-resume = "${lib.getExe pkgs.brightnessctl} -r";
          }

          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }

          {
            timeout = 630;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enableXdgAutostart = true;
    settings = {
      ecosystem.no_update_news = true;
      monitor = ",highres,auto-up,1";

      source = [
        "~/.config/hypr/monitors.conf"
        "~/.config/hypr/workspaces.conf"
      ];

      exec-once =
        [
          "hyprpaper"
          "waybar"
          "xwaylandvideobridge"
          "pypr"
        ]
        ++ (
          let
            targets = [
              "text"
              "image"
            ];
          in
          (builtins.genList (i: "wl-paste --type ${builtins.elemAt targets i} --watch cliphist store") (
            builtins.length targets
          ))
        );

      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "no";
        };
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 2;
        gaps_out = 0;
        border_size = 1;
        "col.active_border" = "rgba(cdd6f4ee)";
        "col.inactive_border" = "rgba(1e1e2eaa)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 3;

        blur = {
          enabled = true;
          popups = true;
          ignore_opacity = false;
          xray = false;
          size = 4;
          passes = 4;
          contrast = 1.5;
          brightness = 1;
          vibrancy = 0.1697;
          noise = 0;
        };
      };

      animations = {
        enabled = "yes";

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 0, 2, default"
        ];
      };

      windowrule =
        (map (e: "float, ${e}") [
          "class:kitty"
          "class:com.mitchellh.ghostty"
          "class:jetbrains-.*, title:Welcome to.*$"
          "class:satty"
        ])
        ++ (map (e: "noblur, ${e}") [
          "class:kitty"
          "class:com.mitchellh.ghostty"
        ])
        ++ (map (e: "opacity 0.9, ${e}") [
          "class:discord"
          "class:vesktop"
          "class:obsidian"
          "class:waybar"
          "class:Rofi"
          "class:jetbrains-.*"
          "class:code"
        ])
        ++ (map (e: "opacity 0, ${e}") [
          "class:xwaylandvideobridge"
        ])
        ++ [
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "size 600 400, title:^(Picture-in-Picture)$"
        ];

      dwindle = {
        preserve_split = "yes";
        smart_split = "yes";
        smart_resizing = "yes";
      };

      gestures = {
        workspace_swipe = "on";
        workspace_swipe_invert = false;
      };

      # ↓ Keybinds ↓

      "$mod" = "SUPER";

      bind =
        [
          # General Keybinds
          "$mod, return, exec, ghostty"
          "$mod, W, killactive,"
          "$mod, F, togglefloating,"
          "$mod, R, exec, rofi -show drun"
          "$mod, J, togglesplit,"
          "$mod, K, fullscreen,"
          "$mod, O, exec, pkill -SIGUSR1 waybar # Waybar toggle"
          "$mod, L, exec, loginctl lock-session"

          "$mod, Z, exec, pypr zoom ++0.5"
          "$mod ctrl, Z, exec, pypr zoom"

          # Move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod shift, N, exec, swaync-client -t -sw"

          "$mod, V, exec, cliphist list | ${lib.getExe pkgs.wofi} --dmenu | cliphist decode | wl-copy"
        ]
        ++ (
          let
            letters = [
              "A"
              "Z"
              "E"
              "R"
              "T"
              "Y"
              "U"
              "I"
              "O"
              "P"
            ];
            workspaceKeybinds = id: key: [
              "$mod shift, ${key}, exec, hyprqtile move ${id}"
              "$mod alt,   ${key}, movetoworkspace, ${id}"
            ];
          in
          with builtins;
          concatLists (genList (x: workspaceKeybinds (toString (x + 1)) (elemAt letters x)) (length letters))
        )
        ++ [
          # Scroll through existing workspaces
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Screenshot Keybinds
          ", Print, exec, ${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" - | ${lib.getExe pkgs.satty} -f -"
          "$mod, Print, exec, kooha -f -"
        ];

      binde = [
        # Brightness
        ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

        # Volume Control Keybinds
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

        # ",Caps_Lock, exec, swayosd-client --caps-lock"

        # Media Control Keybinds
        ",XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
        ",XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"

        # Select monoitors
        "$mod, p, exec, nwg-displays"
      ];
      bindl = [ ",XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause" ];

      bindm = [
        # Move/resize windows
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  xdg.configFile = {
    "hypr/hyprpaper.conf".text = ''
      preload = ~/assets/wallpapers/wavy-milad-fakurian.jpg
      wallpaper = , ~/assets/wallpapers/wavy-milad-fakurian.jpg
      splash = false
    '';

    "hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
        "magnify",
      ]

      [magnify]
      factor = 4
    '';
  };
}
