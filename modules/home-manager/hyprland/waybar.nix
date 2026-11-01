{
  pkgs,
  inputs,
  ...
}: let
  text-color = "#ffffff";
  gradient = "linear-gradient(0deg, rgba(34,34,30,1) 60%, rgba(16,37,54,1) 100%)";
in {
  programs.waybar = {
    enable = true;
    settings = {
      Main = {
        layer = "top";
        position = "top";
        height = 35;
        margin-top = 5;

        modules-center = [
          "hyprland/workspaces"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "sway/language"
          "battery"
          "tray"
          "clock"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = " {name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          icon-size = 20;
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          # "thermal-zone": 2,
          # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          critical-threshold = 80;
          # "format-critical": "{temperatureC}°C {icon}",
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        backlight = {
          # "device": "acpi_video1",
          format = "{percent}% {icon}";
          format-icons = ["" ""];
        };
        battery = {
          states = {
            # "good": 95,
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # "format-good": "", // An empty format will hide the module
          # "format-full": "",
          format-icons = ["" "" "" "" ""];
        };
        network = {
          # "interface": "wlp2*", // (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Connected  ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click-right = "bash ~/.config/rofi/wifi_menu/rofi_wifi_menu";
        };
        pulseaudio = {
          # "scroll-step": 1, // %, can be a float
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = "{icon} {format_source}";
          format-muted = "{format_source}";
          format-source = "";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
    style = builtins.replaceStrings ["@text-color@" "@gradient@"] [text-color gradient] (builtins.readFile ./waybar.css);
  };
}
