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

        # Update kitty theme
        ln -fs "$XDG_CONFIG_HOME/kitty/$theme.conf" "$XDG_CONFIG_HOME/kitty/current-theme.conf"
        while IFS= read -r -d "" sock; do
          kitty @ --to "unix:$sock" set-colors -a -- "$XDG_CONFIG_HOME/kitty/current-theme.conf" \
            || rm -f "$sock"
        done <   <(find /tmp -maxdepth 1 -name "kitty-*" -type 's' -print0)

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

        # Update waybar theme
        # Note: this is the last step of the script because waybar takes the
        #       whole script into death with it
        ln -fs "$XDG_CONFIG_HOME/waybar/$theme.css" "$XDG_CONFIG_HOME/waybar/theme.css"
        pkill -SIGUSR2 waybar
      '';
    })
  ];
}
