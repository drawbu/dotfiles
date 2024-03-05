{ pkgs, ... }:
let
  colors = import ./colors.nix { };
in
{
  programs.waybar =
    with colors;{
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
        window#waybar {
          background-color: #${darker};
          border-bottom: none;
        }
        * {
          color: #${foreground};
          font-size: 16px;
          min-height: 0;
          font-family: "Iosevka Nerd Font", "Material Design Icons Desktop";
        }

        /* left widgets */

        box > widget > label,
        box > widget > box {
          background-color: #${background};
          margin-top: 4px;
          margin-bottom: 4px;
          padding: 5px 12px;
          border-radius: 5px;
        }

        #custom-launcher {
          color: #${raw.blue};
          margin-left: 4px;
          font-size: 18px;
        }
        #workspaces {
          margin-left: 4px;
          font-size: 20px;
        }
        #workspaces button {
          color: #${raw.blue};
          font-size: 18px;
          background-color: transparent;
          transition: all 0.1s ease;
        }
        #workspaces button.focused {
          color: #${raw.green};
          font-size: 18px;
        }
        #workspaces button.persistent {
          color: #${raw.yellow};
          font-size: 12px;
        }

        /* center widgets */

        #privacy,
        #mpris {
          margin-left: 4px;
        }

        /* right widgets */

        #pulseaudio {
          border-top-right-radius: 0;
          border-bottom-right-radius: 0;
        }
        #bluetooth {
          border-radius: 0;
        }
        #bluetooth.connected {
          color: #${raw.blue};
        }
        #network {
          border-radius: 0;
        }
        #battery {
          margin-right: 4px;
          border-top-left-radius: 0;
          border-bottom-left-radius: 0;
        }
        #battery.charging {
          color: #${raw.green};
        }
        @keyframes blink {
          to {
            background-color: #ffffff;
            color: black;
          }
        }
        #battery.warning:not(.charging) {
          color: #${raw.yellow};
        }
        #battery.critical:not(.charging) {
          background: #${raw.red};
          color: white;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        #tray {
          margin-right: 4px;
        }
        #custom-power {
          color: #${raw.red};
          margin-right: 4px;
        }
      '';
      settings = [{
        height = 35;
        layer = "top";
        position = "top";

        # ↓ Left widgets
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
        ];
        "custom/launcher" = { format = " "; };
        "hyprland/workspaces" = {
          on-click = "activate";
          all-outputs = true;
          format = "{icon}";
          disable-scroll = true;
          active-only = false;
          format-icons = {
            default = "";
            active = "";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        # ↓ Center widgets
        modules-center = [
          "clock"
          "privacy"
          "mpris"
        ];
        clock = {
          format = "{:%d %A %H:%M}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          dynamic-order = [ "artist" "title" ];
          dynamic-importance-order = [ "title" "artist" ];
          dynamic-len = 30;
          player-icons = {
            default = " ";
            spotify = " ";
            spotifyd = " ";
            firefox = " ";
          };
          status-icons = {
            paused = " ";
          };
        };

        # ↓ Right widgets
        modules-right = [
          "pulseaudio"
          "bluetooth"
          "network"
          "battery"
          "tray"
          "custom/power"
        ];
        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "{icon}";
          format-muted = "";
          format-icons = { "default" = [ "" "" ]; };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          tooltip-format = "{volume}%";
        };
        bluetooth = {
          format = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "${pkgs.rofi-bluetooth}/bin/rofi-bluetooth";
        };
        network = {
          interval = 1;
          on-click = "${pkgs.kitty}/bin/kitty -e nmtui";
          format-disconnected = "󰤮 ";
          format-ethernet = "󰈀 ";
          format-wifi = "󰤨 ";
          tootip-format = "{essid}\n\n{bandwidthDownBytes} ↓\n{bandwidthUpOctets} ↑";
          tooltip-format-wifi = "{essid}\t({signalStrength}%)\n\n{bandwidthDownBytes} ↓\n{bandwidthUpOctets} ↑";
          tooltip-format-disconnected = "No connection";
        };
        battery = {
          format = "{icon}";
          format-charging = "󰂄";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-plugged = "󰚦 ";
          states = {
            critical = 10;
            warning = 20;
          };
          tooltip-format = "{capacity}% - {time}";
        };
        tray = { spacing = 10; };
        "custom/power" = {
          on-click = "${pkgs.rofi}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
          format = " ";
          tooltip = "Power menu";
        };
      }];
    };
}
