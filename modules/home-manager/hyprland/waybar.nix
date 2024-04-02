{ pkgs, inputs, ... }: let
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
    style = ''
    * {
    border: none;
    border-radius: 0px;
    font-family: Roboto, Helvetica, Arial, sans-serif;
    font-size: 13px;
    min-height: 0;
    margin: 0;
}

window#waybar {
    background-color: transparent;
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}


#workspaces button {
    background: ${gradient};
    color: ${text-color};
    border-radius: 20px;
}

/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
#workspaces button:hover {
    background: rgba(16,37,54,1);
    color: ${text-color};
    border-bottom: 1px solid #ffffff;

}

#workspaces button.focused {
    background: #1f1f1f;
}

#workspaces button.focused:hover, #workspaces button.active {
    color: ${text-color};
    border-bottom: 1px solid #ffffff;

}

#workspaces button.urgent {
    background-color: #eb4d4b;
}

#mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#custom-media,
#custom-launcher,
#custom-power,
#tray,
#mode,
#idle_inhibitor,
#mpd {
    padding: 5px 10px;
    color: ${text-color};
}

#window,
#workspaces {
    margin: 0px 4px;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
    margin-left: 0px;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
    margin-right: 0px;
}

#clock {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
    border-radius: 0px 20px 20px 0px;
    margin-right: 4px;
}

#battery.charging, #battery.plugged {
    color: #ffffff;
    background-color: #26A65B;
}

@keyframes blink {
    to {
        background-color: #ffffff;
        color: #000000;
    }
}

#battery.critical:not(.charging) {
    background-color: #f53c3c;
    color: #ffffff;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

label:focus {
    background-color: #000000;
}

#battery {
    background-color: #fa8bff;
    background-image: ${gradient};
    color: ${text-color};
}

#cpu {
    background-color: #fa8bff;
    background-image: ${gradient};
    color: ${text-color};
}

#memory {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#disk {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#backlight {
    background-color: #FA8BFF;
    background-image: ${gradient};

}

#network {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#network.disconnected {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: red;
}

#pulseaudio {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#pulseaudio.muted {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: red;
}

#temperature {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#temperature.critical {
    background-color: #eb4d4b;
}

#tray {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#tray > .passive {
    -gtk-icon-effect: dim;
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
}

#idle_inhibitor {
    background-color: #FA8BFF;
    background-image: ${gradient};
    border-radius: 20px 0px 0px 20px;

}

#idle_inhibitor.activated {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
    border-radius: 20px 0px 0px 20px;

}

#language {
    background-color: #FA8BFF;
    background-image: ${gradient};
    color: ${text-color};
    min-width: 16px;
}

#keyboard-state {
    background: #97e1ad;
    color: #000000;
    min-width: 16px;
}

#keyboard-state > label {
    padding: 0px 5px;
}

#keyboard-state > label.locked {
    background: rgba(0, 0, 0, 0.2);
}
    '';
  };
}
