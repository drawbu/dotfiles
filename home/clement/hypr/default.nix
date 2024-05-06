{
  pkgs,
  hyprland,
  ...
}: let
  hyprpaperActivation = import ./symlink.nix {
    inherit pkgs;
    path = "$XDG_CONFIG_HOME/hypr";
    file = "hyprpaper.conf";
    default = "paper/dark.conf";
  };
in {
  imports = [
    ./waybar.nix
    ./hyprlock.nix
    ./colortheme.nix
  ];

  home = {
    activation.createHyprpaper = "sh ${hyprpaperActivation.script}";
    packages = with pkgs.hyprpkgs; [
      hyprpaper
      nwg-displays
      xwaylandvideobridge
      pyprland
      hypridle
      hyprlock
    ];
  };

  services.swayosd.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.hyprland;

    settings = {
      monitor = ",highres,auto,1";

      exec-once =
        [
          "hyprpaper"
          "waybar"
          "xwaylandvideobridge"
          "pypr"
          "hypridle"
        ]
        ++ (
          let
            targets = ["text" "image"];
          in (builtins.genList
            (
              i: "${pkgs.wl-clipboard}/bin/wl-paste --type ${builtins.elemAt targets i} --watch ${pkgs.cliphist}/bin/cliphist store"
            )
            (builtins.length targets))
        );

      env = "XCURSOR_SIZE,16";

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

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
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
          "workspaces, 1, 6, default"
        ];
      };

      windowrule =
        [
          "noblur,^(kitty)$"
        ]
        ++ (builtins.map (e: "float, ${e}") ["^(kitty)$"])
        ++ (builtins.map (e: "opacity 0.9, ${e}") [
          "^(discord)$"
          "^(vesktop)$"
          "^(obsidian)$"
          "^(waybar)$"
          "^(Rofi)$"
        ]);

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
          "$mod, return, exec, kitty"
          "$mod, W, killactive,"
          "$mod, F, togglefloating,"
          "$mod, R, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
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

          "$mod, V, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        ]
        ++ (
          let
            letters = ["A" "Z" "E" "R" "T" "Y"];
          in
            with builtins;
              concatLists (genList
                (x: [
                  "$mod shift, ${elemAt letters x}, workspace,       ${toString (x + 1)}"
                  "$mod alt,   ${elemAt letters x}, movetoworkspace, ${toString (x + 1)}"
                ])
                (length letters))
        )
        ++ [
          # Scroll through existing workspaces
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Screenshot Keybinds
          ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.unstable.satty}/bin/satty -f -"
        ];

      binde = [
        # Brightness Control Keybinds
        ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"

        # Volume Control Keybinds
        ",XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd --output-volume mute-toggle"
        ",XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd --output-volume raise"
        ",XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd --output-volume lower"
        ",XF86AudioMicMute, exec, ${pkgs.swayosd}/bin/swayosd --input-volume mute-toggle"

        # Media Control Keybinds
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ];
      bindl = [
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ];

      bindm = [
        # Move/resize windows
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  xdg.configFile = {
    "hypr/paper/dark.conf".text = ''
      preload = ${../../../assets/wallpapers/japan-market.jpg}
      wallpaper = ,${../../../assets/wallpapers/japan-market.jpg}
    '';
    "hypr/paper/light.conf".text = ''
      preload = ${../../../assets/wallpapers/sunflower.jpg}
      wallpaper = ,${../../../assets/wallpapers/sunflower.jpg}
    '';

    "hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = [
        "magnify",
      ]

      [magnify]
      factor = 4
    '';

    "hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
      }

      listener {
          timeout = 150
          on-timeout = ${pkgs.brightnessctl}/bin/brightnessctl -s set 10
          on-resume = ${pkgs.brightnessctl}/bin/brightnessctl -r
      }

      listener {
          timeout = 600
          on-timeout = loginctl lock-session
      }

      listener {
          timeout = 630
          on-timeout = systemctl suspend
      }
    '';
  };
}
