{ ... }:
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

        #custom-launcher {
          background-color: #${background};
          color: #${raw.blue};
          margin: 4px 0 4px 4px;
          padding: 5px 12px;
          font-size: 18px;
          border-radius: 5px;
        }
        #workspaces {
          background-color: #${background};
          margin: 4px 0 4px 4px;
          font-size: 20px;
          border-radius: 5px;
        }
        #workspaces button {
          font-size: 18px;
          background-color: transparent;
          color: #${raw.blue};
          transition: all 0.1s ease;
        }
        #workspaces button.focused {
          font-size: 18px;
          color: #${raw.green};
        }
        #workspaces button.persistent {
          color: #${raw.yellow};
          font-size: 12px;
        }

        /* center widgets */

        #clock {
          background-color: #${background};
          margin: 4px 0 4px 0;
          padding: 5px 12px;
          border-radius: 5px;
        }
        #privacy {
          background-color: #${background};
          margin: 4px 0 4px 4px;
          padding: 5px 12px;
          border-radius: 5px;
        }
        #mpris {
          background-color: #${background};
          margin: 4px 0 4px 4px;
          padding: 5px 12px;
          border-radius: 5px;
        }

        /* right widgets */

        #pulseaudio {
          background-color: #${background};
          margin: 4px 0 4px 0;
          padding: 5px 12px;
          border-radius: 5px 0 0 5px;
        }
        #bluetooth {
          background-color: #${background};
          margin: 4px 0 4px 0;
          padding: 5px 12px;
        }
        #bluetooth.connected {
          color: #${raw.blue};
        }
        #network {
          background-color: #${background};
          margin: 4px 0 4px 0;
          padding: 5px 12px;
        }
        #battery {
          background-color: #${background};
          margin: 4px 4px 4px 0;
          padding: 5px 12px;
          border-radius: 0 5px 5px 0;
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
          background-color: #${background};
          margin: 4px 4px 4px 0;
          padding: 5px 11px 5px 13px;
          border-radius: 5px;
        }
        #custom-power {
          background-color: #${background};
          color: #${raw.red};
          margin: 4px 4px 4px 0;
          padding: 5px 11px 5px 13px;
          border-radius: 5px;
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
          dynamic-order = ["artist" "title"];
          dynamic-importance-order = ["title" "artist"];
          dynamic-len = 30;
          player-icons = {
              default = " ";
              spotify = " ";
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
          format-icons = { "default" = ["" ""]; };
          on-click = "pavucontrol";
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
          on-click = "rofi-bluetooth";
        };
        network = {
          interval = 1;
          on-click = "kitty -e nmtui";
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
          on-click = "powermenu";
          format = " ";
          tooltip-format = "Power menu";
        };
      }];
    };
}
