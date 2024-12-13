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
        notify-send "Switching to $theme theme"

        # Update kitty theme
        echo "[DARK] Updating kitty theme..."
        ln -fs "$XDG_CONFIG_HOME/kitty/$theme.conf" "$XDG_CONFIG_HOME/kitty/current-theme.conf"
        while IFS= read -r -d "" sock; do
          kitty @ --to "unix:$sock" set-colors -a -- "$XDG_CONFIG_HOME/kitty/current-theme.conf" \
            || rm -f "$sock"
        done <   <(find /tmp -maxdepth 1 -name "kitty-*" -type 's' -print0)

        # Update css theme
        echo "[DARK] Updating css theme..."
        ln -fs "$HOME/$theme.css" "$HOME/theme.css"

        # Update waybar theme
        echo "[DARK] Updating waybar theme..."
        ln -fs "$XDG_CONFIG_HOME/waybar/$theme.css" "$XDG_CONFIG_HOME/waybar/theme.css"
        pkill -SIGUSR2 waybar

        # Update gtk theme
        if ${shBool config.gtk.enable}; then
          echo "[DARK] Updating GTK theme..."
          gtk_theme="Catppuccin-Mocha-Compact-Peach-Dark";
          if [ "$theme" = "light" ]; then
            gtk_theme="Catppuccin-Latte-Compact-Peach-Light";
          fi

          echo "[org/gnome/desktop/interface]
          color-scheme='prefer-$theme'
          gtk-theme='$gtk_theme'" | dconf load /
        fi

        # Update wallpaper
        if pidof swww-daemon; then
          echo "[DARK] Updating swww..."
          ln -fs "$XDG_CONFIG_HOME/hypr/paper/$theme" "$XDG_CONFIG_HOME/hypr/paper/current"
          swww img "$(realpath "$XDG_CONFIG_HOME/hypr/paper/current")" --transition-type wipe
        fi
      '';
    })
  ];
}
