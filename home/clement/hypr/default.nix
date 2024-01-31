{ pkgs, ... }:
let
  wallpaper = ./../../../assets/wallpapers/japan-market.jpg;
in
{
  imports = [
    ./waybar.nix
    ./powermenu.nix
    ./wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    extraConfig = ''
      monitor=,highres,auto,1

      exec-once = waybar & hyprpaper

      env = XCURSOR_SIZE,16

      input {
          kb_layout = fr
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          gaps_in = 2
          gaps_out = 0
          border_size = 1
          col.active_border = rgba(cdd6f4ee)
          col.inactive_border = rgba(1e1e2eaa)

          layout = dwindle
      }

      decoration {
          rounding = 3
          
          blur {
              enabled = true
              size = 3
              passes = 1
          }

          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = yes

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          preserve_split = yes
          smart_split = yes
          smart_resizing = yes
      }

      gestures {
          workspace_swipe = on
          workspace_swipe_invert = false
      }

      # ↓ Keybinds ↓

      $mainMod = SUPER

      # General Keybinds
      bind = $mainMod, return, exec, kitty
      bind = $mainMod, W, killactive, 
      bind = $mainMod, F, togglefloating, 
      bind = $mainMod, R, exec, wofi --show drun
      bind = $mainMod, J, togglesplit, # dwindle

      # Brightness Control Keybinds
      binde = ,XF86MonBrightnessUp, exec, brightnessctl set +5%
      binde = ,XF86MonBrightnessDown, exec, brightnessctl set 5%-

      # Volume Control Keybinds
      binde = ,XF86AudioMute, exec, pamixer --toggle-mute
      binde = ,XF86AudioRaiseVolume, exec, pamixer --increase 5
      binde = ,XF86AudioLowerVolume, exec, pamixer --decrease 5
      binde = ,XF86AudioMicMute, exec, pamixer --default-source -t

      # Media Control Keybinds
      bind = ,XF86AudioPlay, exec, playerctl play-pause
      bind = ,XF86AudioNext, exec, playerctl next
      bind = ,XF86AudioPrev, exec, playerctl previous

      # Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces
      bind = $mainMod shift, A, workspace, 1
      bind = $mainMod shift, Z, workspace, 2
      bind = $mainMod shift, E, workspace, 3
      bind = $mainMod shift, R, workspace, 4
      bind = $mainMod shift, T, workspace, 5
      bind = $mainMod shift, Y, workspace, 6

      # Move active window to a workspace
      bind = $mainMod alt, A, movetoworkspace, 1
      bind = $mainMod alt, Z, movetoworkspace, 2
      bind = $mainMod alt, E, movetoworkspace, 3
      bind = $mainMod alt, R, movetoworkspace, 4
      bind = $mainMod alt, T, movetoworkspace, 5
      bind = $mainMod alt, Y, movetoworkspace, 6

      # Scroll through existing workspaces
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Waybar toggle
      bind = $mainMod, O, exec, pkill -SIGUSR1 waybar
    '';
  };

  home = {
    packages = [ pkgs.hyprpaper ];
    file.".config/hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = ,${wallpaper}
    '';
  };
}
