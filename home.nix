{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Các config folders cần symlink từ dotfiles
    configs = {
      "nvim" = "nvim";
      "qutebrowser";
    };



    # Định nghĩa bộ màu Dracula
    dracula = {
      bg0 = "#282a36";
      bg1 = "#44475a";
      fg = "#f8f8f2";
      green = "#50fa7b";
      blue = "#6272a4";
      yellow = "#f1fa8c";
      gray = "#6272a4";
      red = "#ff5555";
      magenta = "#ff79c6";
      cyan = "#8be9fd";
      purple = "#bd93f9";
      orange = "#ffb86c";
    };

    in

    {
    home.username = "levinhne";
    home.homeDirectory = "/home/levinhne";
    home.stateVersion = "25.11";

    xdg.configFile = builtins.mapAttrs
      (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
      })
      configs;

    # CLI tools
    home.packages = with pkgs; [
      ripgrep
      fd
      fzf
      bat
      eza
      tree
      code
      foot
      swww
      neovim

      # Dev:
      nodejs_24
      python3
      nwg-displays
      nixpkgs-fmt
    ];

    # Git
    programs.git = {
      enable = true;
      userName = "levinhne";
      userEmail = "levinhne@example.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };

    # Bash
    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        ll = "ls -la";
        update = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne";
        clean = "sudo nix-collect-garbage -d";
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
      };
      bashrcExtra = ''
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        if command -v neofetch &> /dev/null; then neofetch; fi
      '';
    };

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      xwayland = true;

      config = rec {
        modifier = "Mod4";
        terminal = "foot";

        # Font
        fonts = {
          names = [ "Iosevka Nerd Font Mono" ];
          size = 11.0;
        };

        # Output
        output = {
          "HDMI-A-1" = { res = "1920x1200"; pos = "0 0"; };
          "DP-1" = { res = "1920x1080"; pos = "1920 0"; };
        };

        # Gaps & Borders
        gaps = {
          inner = 4;
          outer = 4;
        };

        # Window Rules
        window.commands = [
          { command = "floating enable"; criteria = { app_id = "yad"; }; }
          { command = "floating enable, move position center, resize set 600 400"; criteria = { app_id = "org.pulseaudio.pavucontrol"; }; }
        ];

        # Keybindings (Tích hợp phím tắt cũ vào bộ mới)
        keybindings = let mod = modifier; in lib.mkOptionDefault {
          # Launchers
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+b" = "exec google-chrome-stable";
          "${mod}+y" = "exec nemo";

          # Utilities
          "${mod}+v" = "exec cliphist list | rofi -dmenu -p 'Clipboard' -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy";
          "${mod}+s" = "exec rofi -show emoji -modi emoji -matching regex -sorting-method levenshtein";
          "${mod}+c" = "exec ~/.local/bin/random-wallpaper.sh";
          "${mod}+g" = "exec ~/.config/sway/scripts/prompt-record.sh";

          # Window Management
          "${mod}+w" = "kill";
          "${mod}+a" = "exec sticky enable";
          "${mod}+t" = "floating toggle";
          "${mod}+f" = "fullscreen";
          "${mod}+u" = "exec ~/.config/sway/scripts/tiling.sh";

          # System Controls
          "${mod}+Shift+t" = "exec swaylock --screenshots --effect-blur 7x5 --color '${dracula.bg0}' --indicator-radius 100 --font 'Iosevka Nerd Font Mono'";
          "${mod}+Shift+a" = "exec pkill -SIGUSR2 waybar";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut.' -B 'Yes, exit sway' 'swaymsg exit'";
          "ctrl+alt+delete" = "exec nwg-bar";

          # Media Keys
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          "Print" = "exec flameshot gui";

          # Workspaces với Sov integration
          "${mod}+1" = "workspace number 1; exec echo 1 > /tmp/sovpipe";
          "${mod}+2" = "workspace number 2; exec echo 1 > /tmp/sovpipe";
          "${mod}+3" = "workspace number 3; exec echo 1 > /tmp/sovpipe";
          "${mod}+4" = "workspace number 4; exec echo 1 > /tmp/sovpipe";
          "${mod}+5" = "workspace number 5; exec echo 1 > /tmp/sovpipe";
          "${mod}+6" = "workspace number 6; exec echo 1 > /tmp/sovpipe";
          "${mod}+7" = "workspace number 7; exec echo 1 > /tmp/sovpipe";
          "${mod}+8" = "workspace number 8; exec echo 1 > /tmp/sovpipe";
          "${mod}+9" = "workspace number 9; exec echo 1 > /tmp/sovpipe";
          "${mod}+0" = "workspace number 10; exec echo 1 > /tmp/sovpipe";

          # Move container
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          # ... Vinh có thể bổ sung thêm từ 4-0 tương tự
        };

        # Dracula Theme Colors
        colors = {
          focused = {
            border = dracula.purple;
            background = dracula.bg1;
            text = dracula.fg;
            indicator = dracula.cyan;
            childBorder = dracula.purple;
          };
          unfocused = {
            border = dracula.bg0;
            background = dracula.bg1;
            text = dracula.gray;
            indicator = dracula.bg0;
            childBorder = dracula.bg1;
          };
        };

        bars = [{ command = "waybar"; }];

        startup = [
          { command = "swww-daemon"; always = true; }
          { command = "mako"; always = true; }
          { command = "wl-paste --type text --watch cliphist store"; always = true; }
        ];
      };

      # Thêm các phím --release cho Sov 
      extraConfig = ''
        default_border pixel 2
        bindsym --release Mod4+1 exec "echo 0 > /tmp/sovpipe" 
        bindsym --release Mod4+2 exec "echo 0 > /tmp/sovpipe" 
        # ... tương tự cho các phím còn lại 
      '';
    };

    # Waybar
    programs.waybar = {
      enable = true;
      style = builtins.readFile ./config/waybar/style.css;
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

    # Wofi (launcher)
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        allow_images = true;
        prompt = "Run:";
      };
      style = ''
        window { border-radius: 8px; }
      '';
    };

    # Mako (notifications)
    services.mako = {
      enable = true;
      defaultTimeout = 5000;
      backgroundColor = "#333333";
      textColor = "#ffffff";
      borderColor = "#88c0d0";
    };

    # Swayidle + swaylock (lock screen)
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "swaylock -f -c 000000"; }
      ];
      timeouts = [
        { timeout = 600; command = "swaylock -f -c 000000"; } # 10 phút
      ];
    };

    programs.swaylock = {
      enable = true;
      settings = {
        color = "000000";
        ignore-empty-password = true;
        indicator-radius = 120;
      };
    };

    # Home Manager
    programs.home-manager.enable = true;
  }
