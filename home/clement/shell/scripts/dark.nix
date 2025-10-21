{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "dark";
      runtimeInputs = with pkgs; [ libnotify ];
      text = ''
        theme=$(gsettings get org.gnome.desktop.interface color-scheme)
        if [ "$theme" = "'prefer-dark'" ]; then
          theme="light"
        else
          theme="dark"
        fi
        echo "$theme" > "$THEMEFILE"
        notify-send "Switching to $theme theme" -t 1000

        gtk_theme="catppuccin-mocha-peach-compact+rimless";
        if [ "$theme" = "light" ]; then
          gtk_theme="catppuccin-latte-peach-compact+rimless";
        fi

        gsettings set org.gnome.desktop.interface color-scheme "prefer-$theme"
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
      '';
    })
  ];
}
