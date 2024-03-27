{
  config,
  pkgs,
  ...
}: let
  dark = pkgs.writeShellScriptBin "dark" ''
    theme=$(cat $THEMEFILE)
    if [ "$theme" = "light" ]; then
        theme="dark"
    else
        theme="light"
    fi
    notify-send "Switching to $theme theme"

    echo $theme > $THEMEFILE

    # Update kitty theme
    for sock in $(find /tmp -maxdepth 1 -name "kitty-*" -type 's'); do
      ${pkgs.kitty}/bin/kitty @ --to unix:$sock set-colors -a -- "$XDG_CONFIG_HOME/kitty/$theme.conf"
    done

    # Update css theme
    css="$HOME/theme.css"
    rm -f $css
    ln -s "$HOME/$theme.css" $css

    # Update waybar theme
    css="$XDG_CONFIG_HOME/waybar/theme.css"
    rm -f $css
    ln -s "$XDG_CONFIG_HOME/waybar/$theme.css" $css
    pkill waybar && waybar &

    # Update gtk theme
    gtk_theme=${config.gtk.theme.name}
    if [ $theme = "light" ]; then
      gtk_theme="Catppuccin-Latte-Compact-Peach-Dark";
    fi
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme

    # Update wallpaper
    file=$XDG_CONFIG_HOME/hypr/hyprpaper.conf
    rm -f $file
    ln -s "$XDG_CONFIG_HOME/hypr/paper/$theme.conf" $file
    pkill hyprpaper && hyprpaper &
  '';

  run_gnome = pkgs.writeShellScriptBin "run_gnome" ''
    export DISPLAY=:0
    export XDG_SESSION_TYPE=wayland
    ${pkgs.dbus}/bin/dbus-run-session ${pkgs.gnome.gnome-session}/bin/gnome-session
  '';

  fixwifi = let
    nmcli = "${pkgs.networkmanager}/bin/nmcli";
  in
    pkgs.writeShellScriptBin "fixwifi" ''
      ssid="$1"
      if [ -z "$ssid" ]; then
        echo "Usage: fixwifi <ssid>"
        exit 1
      fi
      while [ -z "$((${nmcli} dev wifi rescan && ${nmcli} dev wifi list) | grep "$ssid")" ]; do
        echo "Waiting for $ssid to be available..."
        sleep 1
      done
      echo "Connecting to $ssid..."
      ${nmcli} dev wifi connect "$ssid"
    '';
in {
  home.packages = [
    fixwifi
    dark
    run_gnome
  ];
}
