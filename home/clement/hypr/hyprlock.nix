{config, ...}: let
  colors = import ./colors.nix {theme = "dark";};
in {
  xdg.configFile."hypr/hyprlock.conf".text = ''
    # https://github.com/specarino/dotfiles/blob/f4fc7bd5f67628dc41f19d86be8b8922a3592b65/.config/hypr/hyprlock.conf
    source = ${config.home.homeDirectory}/theme.css

    general {
      ignore_empty_input = true
    }

    background {
      monitor =
      path = ${../../../assets/wallpapers/diner.png}
      color = ${colors.raw.base.css}

      # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
      blur_passes = 4
      blur_size = 6
      noise = 0.05
      contrast = 1.0
      brightness = 0.8
      vibrancy = 0.15
      vibrancy_darkness = 1.0
    }

    input-field {
      monitor =

      shadow_passes = 4
      shadow_size = 6
      shadow_color = ${colors.raw.sapphire.css}
      shadow_boost = 1.0

      size = 120, 40
      outline_thickness = 4
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = ${colors.raw.sapphire.css}
      inner_color = ${colors.raw.base.css}
      font_color = ${colors.raw.text.css}
      fade_on_empty = false
      fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
      placeholder_text = <i></i> # Text rendered in the input box when it's empty.
      hide_input = false
      rounding = -1 # -1 means complete rounding (circle/oval)
      check_color = ${colors.raw.yellow.css}
      fail_color = ${colors.raw.red.css} # if authentication failed, changes outer_color and fail message color
      # fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
      fail_text = <i></i>
      fail_transition = 300 # transition time in ms between normal outer_color and fail_color
      capslock_color = -1
      numlock_color = -1
      bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false # change color if numlock is off
      swap_font_color = false # see below

      position = 0, -20
      halign = center
      valign = center
    }
  '';
}
