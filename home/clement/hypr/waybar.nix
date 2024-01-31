{ pkgs, ... }:
let
  colors = import ./colors.nix { };
in
{
  home.packages = with pkgs; [
    material-design-icons
    material-icons
    material-symbols
  ];
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
          color: #${foreground};
          border-bottom: none;
        }
        #workspaces {
          font-family: "Material Design Icons Desktop";
          font-size: 20px;
          background-color: #${background};
          margin : 4px 0;
          border-radius : 5px;
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
        #custom-launcher {
          background-color: #${background};
          color: #${raw.blue};
          margin : 4px 4.5px;
          padding : 5px 12px;
          font-size: 18px;
          border-radius : 5px;
        }
        #custom-power {
          background-color: #${background};
          color : #${raw.red};
          margin : 4px 4.5px 4px 4.5px;
          padding : 5px 11px 5px 13px;
          border-radius : 5px;
        }

        #clock {
          background-color: #${background};
          color: #${foreground};
          margin : 4px 9px;
          padding : 5px 12px;
          border-radius : 5px;
        }
        
        #network {
          background-color: #${background};
          color : #${raw.blue};
          margin : 4px 0 4px 4.5px;
          padding : 5px 12px;
          border-radius : 5px 0 0 5px;
        }
        #battery {
          background-color: #${background};
          color : #${raw.mauve};
          margin : 4px 0px;
          padding : 5px 12px;
          border-radius : 5px 0 0 5px;
        }
        #custom-swallow {
          background-color: #${background};
          margin : 4px 4.5px;
          padding : 5px 12px;
          border-radius : 5px;
        }
        * {
          font-size: 16px;
          min-height: 0;
          font-family: "Iosevka Nerd Font", "Material Design Icons Desktop";
        }
      '';
      settings = [{
        height = 35;
        layer = "top";
        position = "top";
        tray = { spacing = 10; };

        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "network"
          "battery"
          "custom/power"
          "tray"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          all-outputs = true;
          format = "{icon}";
          disable-scroll = true;
          active-only = false;
          format-icons = {
            default = "󰊠 ";
            active = "󰮯 ";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        battery = {
          format = "{icon}";
          format-charging = "󰂄";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-plugged = "󰚦 ";
          states = {
            critical = 15;
            warning = 30;
          };
          tootip-format = "{capacity} - {time}";
        };
        clock = {
          format = "{:%d %A %H:%M}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        network = {
          interval = 1;
          on-click = "kitty -e nmtui";
          format-disconnected = "󰤮 ";
          format-ethernet = "󰈀 ";
          format-wifi = "󰤨 ";
          tootip-format = "{essid} - {bandwidthDownBytes} ↓ {bandwidthUpOctets} ↑";
        };
        "custom/launcher" = {
          format = " ";
        };
        "custom/power" = {
          on-click = "powermenu";
          format = " ";
        };
      }];
    };
}
