{ pkgs, ... }:
{
  imports = [ ./dark.nix ];
  home.packages = [
    (pkgs.writeShellApplication {
      name = "fixwifi";
      runtimeInputs = [ pkgs.networkmanager ];
      text = ''
        ssid="$1"
        if [ -z "$ssid" ]; then
          echo "Usage: fixwifi <ssid>"
          exit 1
        fi
        while ! (nmcli dev wifi rescan && nmcli dev wifi list | grep -q "$ssid"); do
          echo "Waiting for $ssid to be available..."
          sleep 1
        done
        echo "Connecting to $ssid..."
        nmcli dev wifi connect "$ssid"
      '';
    })
  ];
}
