{
  config,
  pkgs,
  ...
}: let
  dark = pkgs.writeShellApplication {
    name = "dark";
    text = ''
      theme=$(cat "$THEMEFILE")
      if [ "$theme" = "light" ]; then
          theme="dark"
      else
          theme="light"
      fi
      notify-send "Switching to $theme theme"

      echo "$theme" > "$THEMEFILE"

      # Update kitty theme
      while IFS= read -r -d "" sock; do
        kitty @ --to "unix:$sock" set-colors -a -- "$XDG_CONFIG_HOME/kitty/$theme.conf" \
          || rm -f "$sock"
      done <   <(find /tmp -maxdepth 1 -name "kitty-*" -type 's' -print0)

      # Update css theme
      css="$HOME/theme.css"
      rm -f "$css"
      ln -s "$HOME/$theme.css" "$css"

      # Update waybar theme
      css="$XDG_CONFIG_HOME/waybar/theme.css"
      rm -f "$css"
      ln -s "$XDG_CONFIG_HOME/waybar/$theme.css" "$css"
      pkill waybar && waybar &

      # Update gtk theme
      gtk_theme=${config.gtk.theme.name}
      if [ "$theme" = "light" ]; then
        gtk_theme="Catppuccin-Latte-Compact-Peach-Light";
      fi
      gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"

      # Update wallpaper
      file=$XDG_CONFIG_HOME/hypr/hyprpaper.conf
      rm -f "$file"
      ln -s "$XDG_CONFIG_HOME/hypr/paper/$theme.conf" "$file"
      pkill hyprpaper && hyprpaper &
    '';
  };

  fixwifi = let
    nmcli = "${pkgs.networkmanager}/bin/nmcli";
  in
    pkgs.writeShellApplication {
      name = "fixwifi";
      text = ''
        ssid="$1"
        if [ -z "$ssid" ]; then
          echo "Usage: fixwifi <ssid>"
          exit 1
        fi
        while (${nmcli} dev wifi rescan && ${nmcli} dev wifi list) | grep -q "$ssid"; do
          echo "Waiting for $ssid to be available..."
          sleep 1
        done
        echo "Connecting to $ssid..."
        ${nmcli} dev wifi connect "$ssid"
      '';
    };
in {
  home.packages = [
    fixwifi
    dark
  ];
}
