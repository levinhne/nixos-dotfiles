{ ... }:

{
  # Waybar
  programs.waybar = {
    enable = true;
    style = builtins.readFile ../../config/waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = "1";
        margin = "0";

        modules-left = [
          "custom/arch"
          "sway/workspaces"
          "sway/window"
        ];

        modules-center = [ ];

        modules-right = [
          "sway/mode"
          "custom/updates"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "disk"
          "custom/uptime"
          "clock"
        ];

        "custom/arch" = {
          format = "󰣇";
          tooltip = false;
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          format-icons = {
            "1" = "󰖟";
            "2" = "";
            "3" = "";
            "4" = "󰭹";
            "5" = "󰕧";
            "6" = "";
            "7" = "";
            "8" = "󰣇";
            "9" = "";
            "10" = "";
          };
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        "sway/window" = {
          format = "{title}";
          max-length = 50;
          tooltip = true;
        };

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "custom/updates" = {
          format = "󰚰 {}";
          exec = "~/.config/waybar/check-updates.sh";
          interval = 3600;
          on-click = "kitty -e sudo pacman -Syu"; # Lưu ý: Trên NixOS bạn thường dùng 'nh os switch' hoặc 'nixos-rebuild'
          signal = 8;
        };

        "custom/uptime" = {
          format = "󰔟 {}";
          exec = "uptime -p | sed 's/up //; s/ days/d/; s/ hours/h/; s/ minutes/m/'";
          interval = 60;
        };

        "clock" = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃮 {:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#d3c6aa'><b>{}</b></span>";
              days = "<span color='#e67e80'>{}</span>";
              weeks = "<span color='#a7c080'><b>W{}</b></span>";
              weekdays = "<span color='#7fbbb3'><b>{}</b></span>";
              today = "<span color='#dbbc7f'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "cpu" = {
          format = "󰘚 {usage}%";
          tooltip = true;
          interval = 1;
          on-click = "kitty -e htop";
        };

        "memory" = {
          format = "󰍛 {}%";
          interval = 1;
          on-click = "kitty -e htop";
        };

        "network" = {
          format-wifi = "󰖩 {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ifname}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname}: {ipaddr}";
          on-click = "kitty -e nmtui";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "󰂰 {volume}%";
          format-bluetooth-muted = "󰂲 {icon}";
          format-muted = "󰝟";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰥰";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰄝";
            car = "󰄋";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -2%";
        };

        "disk" = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
          on-click = "kitty -e gdu /";
        };
      };
    };
  };
}
