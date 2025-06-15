{ config, pkgs, ... }:
let
  shBool = x: if x then "true" else "false";
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "dark";
      text = ''
        set +e errexit # Don't exit on error

        theme=$(cat "$THEMEFILE")
        if [ "$theme" = "light" ]; then
          theme="dark"
        else
          theme="light"
        fi
        echo "$theme" > "$THEMEFILE"
        notify-send "Switching to $theme theme" -t 1000

        # Update css theme
        ln -fs "$HOME/$theme.css" "$HOME/theme.css"

        # Update gtk theme
        if ${shBool config.gtk.enable}; then
          gtk_theme="catppuccin-mocha-peach-compact+rimless";
          if [ "$theme" = "light" ]; then
            gtk_theme="catppuccin-latte-peach-compact+rimless";
          fi

          gsettings set org.gnome.desktop.interface color-scheme "prefer-$theme"
          gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
        fi
      '';
    })
  ];
}
