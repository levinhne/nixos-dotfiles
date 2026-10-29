{ config, lib, osConfig, pkgs, ... }:

let
  p = config.lib.stylix.colors.withHashtag;
  vpnEnabled = osConfig.programs.openvpn3.enable or false;
  waybarForCurrentWm = pkgs.writeShellScript "waybar-current-wm" ''
    if [ -n "''${SWAYSOCK:-}" ]; then
      exec ${pkgs.waybar}/bin/waybar -c "$HOME/.config/waybar/config-sway.jsonc" -s "$HOME/.config/waybar/style.css"
    fi

    exec ${pkgs.waybar}/bin/waybar -c "$HOME/.config/waybar/config" -s "$HOME/.config/waybar/style.css"
  '';

  barBase = {
    layer = "top";
    position = "top";
    height = 30;
    spacing = 1;
    margin = "0";
    modules-center = [ ];
  };

  commonModules = with p; {
    "custom/arch" = {
      format = "󱄅";
      tooltip = false;
    };

    "custom/uptime" = {
      format = "󰔟 {}";
      exec = "awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); if (d>0) printf \"%dd %dh\", d, h; else if (h>0) printf \"%dh %dm\", h, m; else printf \"%dm\", m}' /proc/uptime";
      interval = 60;
    };

    clock = {
      format = "󰥔 {:%H:%M}";
      format-alt = "󰥔 {:%a, %b %d - %H:%M}";
      tooltip-format = "<big>{:%A, %d %B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      calendar = {
        mode = "month";
        mode-mon-col = 3;
        weeks-pos = "right";
        on-scroll = 1;
        on-click-right = "mode";
        format = {
          months = "<span color='${base05}'><b>{}</b></span>";
          days = "<span color='${base08}'>{}</span>";
          weeks = "<span color='${base0B}'><b>W{}</b></span>";
          weekdays = "<span color='${base0C}'><b>{}</b></span>";
          today = "<span color='${base0A}'><b><u>{}</u></b></span>";
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

    cpu = {
      format = "󰘚 {usage}%";
      tooltip = true;
      interval = 1;
      on-click = "kitty -e htop";
    };

    memory = {
      format = "󰍛 {}%";
      interval = 1;
      on-click = "kitty -e htop";
    };

    network = {
      format-wifi = "󰖩 {essid} ({signalStrength}%)";
      format-ethernet = "󰈀 {ifname}";
      format-linked = "󰈀 {ifname} (No IP)";
      format-disconnected = "󰖪 Disconnected";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
      tooltip-format = "{ifname}: {ipaddr}";
      on-click = "kitty -e nmtui";
    };

    pulseaudio = {
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

    disk = {
      interval = 30;
      format = "󰋊 {percentage_used}%";
      path = "/";
      on-click = "kitty -e gdu /";
    };

    # Scripts từ home/wm/vpn.nix; vpn-rofi gửi SIGRTMIN+8 để cập nhật ngay
    "custom/vpn" = {
      exec = "vpn-status";
      return-type = "json";
      interval = 5;
      signal = 8;
      on-click = "vpn-rofi";
    };
  };

  commonModulesRight = lib.optional vpnEnabled "custom/vpn" ++ [
    "pulseaudio"
    "network"
    "cpu"
    "memory"
    "disk"
    "custom/uptime"
    "clock"
  ];
in
{
  # Waybar
  programs.waybar = {
    enable = true;
    style = with p; ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Iosevka NF SemiBold";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background-color: ${base00};
          color: ${base05};
      }

      #custom-arch, #mode, #clock, #cpu,
      #memory, #temperature, #battery, #network, #pulseaudio,
      #backlight, #disk, #custom-uptime, #custom-vpn,
      #scratchpad, #idle_inhibitor, #tray {
          padding: 0 10px;
          margin: 0 2px;
          border-bottom: 2px solid transparent;
          background-color: transparent;
      }

      #custom-arch {
          color: ${base0D};
          font-size: 20px;
          font-weight: bold;
          padding: 0 8px;
          margin-right: 10px;
      }

      #workspaces {
          margin-right: 10px;
      }

      #workspaces button {
          padding: 0 8px;
          background-color: transparent;
          color: ${base05};
          font-size: 16px;
      }

      #workspaces button:hover {
          background: ${base01};
          box-shadow: inherit;
      }

      #workspaces button.focused {
          color: ${base0C};
          font-weight: 900;
      }

      #workspaces button.urgent {
          background-color: ${base08};
          color: ${base00};
      }

      #mode {
          color: ${base09};
          border-bottom-color: ${base09};
      }

      #clock {
          color: ${base0D};
          border-bottom-color: ${base0D};
      }

      #cpu {
          color: ${base0B};
          border-bottom-color: ${base0B};
      }

      #memory {
          color: ${base0E};
          border-bottom-color: ${base0E};
      }

      #temperature {
          color: ${base0A};
          border-bottom-color: ${base0A};
      }

      #temperature.critical {
          color: ${base08};
          border-bottom-color: ${base08};
      }

      #battery {
          color: ${base0C};
          border-bottom-color: ${base0C};
      }

      #battery.charging, #battery.plugged {
          color: ${base0B};
          border-bottom-color: ${base0B};
      }

      #battery.warning:not(.charging) {
          color: ${base0A};
          border-bottom-color: ${base0A};
      }

      #battery.critical:not(.charging) {
          color: ${base08};
          border-bottom-color: ${base08};
      }

      #network {
          color: ${base0D};
          border-bottom-color: ${base0D};
      }

      #network.disconnected {
          color: ${base08};
          border-bottom-color: ${base08};
      }

      #pulseaudio {
          color: ${base09};
          border-bottom-color: ${base09};
      }

      #pulseaudio.muted {
          color: ${base08};
          border-bottom-color: ${base08};
      }

      #backlight {
          color: ${base0A};
          border-bottom-color: ${base0A};
      }

      #disk {
          color: ${base0C};
          border-bottom-color: ${base0C};
      }

      #custom-uptime {
          color: ${base0B};
          border-bottom-color: ${base0B};
      }

      #custom-vpn {
          color: ${base03};
      }

      #custom-vpn.connected {
          color: ${base0B};
          border-bottom-color: ${base0B};
      }

      #custom-vpn.connecting, #custom-vpn.auth {
          color: ${base0A};
          border-bottom-color: ${base0A};
      }

      #scratchpad {
          color: ${base0A};
          border-bottom-color: ${base0A};
      }

      #idle_inhibitor {
          color: ${base05};
          border-bottom-color: transparent;
      }

      #idle_inhibitor.activated {
          color: ${base08};
          border-bottom-color: ${base08};
      }

      #tray {
          background-color: transparent;
          padding: 0 10px;
          margin: 0 2px;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          color: ${base08};
          border-bottom-color: ${base08};
      }
    '';
    settings = {
      mainBar = barBase // commonModules // {
        modules-left = [
          "custom/arch"
          "niri/workspaces"
          "niri/window"
        ];

        modules-right = commonModulesRight;

        "niri/workspaces" = {
          format = "{index}";
          all-outputs = false;
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
        };
      };
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${waybarForCurrentWm}";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
    };
  };

  xdg.configFile."waybar/config-sway.jsonc".text = builtins.toJSON [
    (barBase // commonModules // {
      modules-left = [
        "custom/arch"
        "sway/workspaces"
        "sway/window"
      ];

      modules-right = [ "sway/mode" "sway/scratchpad" ] ++ commonModulesRight;

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = false;
        format = "{name}";
        # Each bar only shows its own monitor's workspaces
        # (matches workspaceOutputAssign in sway.nix).
        persistent-workspaces = {
          "1" = [ "HDMI-A-1" ];
          "2" = [ "HDMI-A-1" ];
          "3" = [ "HDMI-A-1" ];
          "4" = [ "DP-1" ];
          "5" = [ "DP-1" ];
          "6" = [ "DP-1" ];
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

      # Hidden (scratchpad) window count; hidden when empty, click to cycle.
      "sway/scratchpad" = {
        format = "󰈉 {count}";
        show-empty = false;
        tooltip-format = "{app}: {title}";
        on-click = "swaymsg scratchpad show";
      };
    })
  ];
}
