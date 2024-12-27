{pkgs, ...}: let
  colors = import ./colors.nix {theme = "dark";};
  theme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "f74ab1eecf2dcaf22569b396eed53b2b2fbe8aff";
    hash = "sha256-WLJMA2X20E5PCPg0ZPtSop0bfmu+pLImP9t8A8V4QK8=";
  };

  activation = import ./symlink.nix {
    inherit pkgs;
    path = "/home/clement/.config/waybar";
    file = "theme.css";
    default = "dark.css";
  };
in {
  xdg.configFile = {
    "waybar/dark.css".source = "${theme}/themes/mocha.css";
    "waybar/light.css".source = "${theme}/themes/latte.css";
  };
  home.activation.createWaybarGTKTheme = "sh ${activation.script}";

  programs.waybar = with colors; {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = /*css*/ ''
      @import "./theme.css";

      window#waybar {
        background-color: ${darker.gtk};
        border-bottom: none;
      }
      * {
        color: ${foreground.gtk};
        font-size: 16px;
        min-height: 0;
        font-family: "Inter", "JetBrainsMono Nerd Font";
      }

      /* left widgets */

      box > widget > label,
      box > widget > box {
        background-color: ${background.gtk};
        margin-top: 4px;
        margin-bottom: 4px;
        padding: 5px 12px;
        border-radius: 5px;
      }

      #custom-launcher {
        color: ${raw.blue.gtk};
        margin-left: 4px;
        font-size: 18px;
      }
      #workspaces {
        margin-left: 4px;
        font-size: 20px;
      }
      #workspaces button {
        color: ${raw.blue.gtk};
        font-size: 18px;
        background-color: transparent;
        transition: all 0.1s ease;
      }
      #workspaces button.focused {
        color: ${raw.green.gtk};
        font-size: 18px;
      }
      #workspaces button.persistent {
        color: ${raw.yellow.gtk};
        font-size: 12px;
      }

      /* center widgets */

      #clock,
      #privacy,
      #mpris {
        margin-left: 4px;
      }

      #mpris.playing.spotify,
      #mpris.playing.spotifyd {
        color: ${raw.green.gtk};
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
        color: ${raw.blue.gtk};
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
        color: ${raw.green.gtk};
      }
      @keyframes blink {
        to {
          background-color: #ffffff;
          color: black;
        }
      }
      #battery.warning:not(.charging) {
        color: ${raw.yellow.gtk};
      }
      #battery.critical:not(.charging) {
        background: ${raw.red.gtk};
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
    '';
    settings = [
      {
        height = 35;
        layer = "top";
        position = "top";

        # ↓ Left widgets
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
        ];
        "custom/launcher" = {
          format = " ";
          on-click = "nwg-displays";
        };
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
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        # ↓ Center widgets
        modules-center = [
          "custom/dark-switch"
          "clock"
          "privacy"
          "mpris"
        ];
        "custom/dark-switch" = {
          format = "󱎖 ";
          on-click = "dark";
          tooltip = "Dark mode";
        };
        clock = {
          format = "{:%d %A %H:%M}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          dynamic-order = [
            "artist"
            "title"
          ];
          dynamic-importance-order = [
            "title"
            "artist"
          ];
          dynamic-len = 30;
          player-icons = rec {
            default = " ";
            spotify = " ";
            spotifyd = spotify;
            firefox = " ";
          };
          status-icons = {
            paused = " ";
          };
        };

        # ↓ Right widgets
        modules-right = [
          "tray"
          "pulseaudio"
          "bluetooth"
          "network"
          "battery"
        ];
        tray = {
          spacing = 10;
        };
        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "{icon}";
          format-muted = "";
          format-icons = {
            "default" = [
              ""
              ""
            ];
          };
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
          on-click = pkgs.lib.getExe pkgs.rofi-bluetooth;
        };
        network = {
          interval = 1;
          on-click = "ghostty -e nmtui";
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
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-plugged = "󰚦 ";
          states = {
            critical = 10;
            warning = 20;
          };
          tooltip-format = "{capacity}% - {time}";
        };
      }
    ];
  };
}
