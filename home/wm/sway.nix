{ config, pkgs, lib, fonts, ... }:

let
  p = config.lib.stylix.colors;
  c = config.lib.stylix.colors.withHashtag;
  common = import ./common.nix { inherit pkgs fonts; palette = p; paletteWithHash = c; };
in

let
  modifier = "Mod4";
  terminal = common.terminal;
  browser = common.apps.browser;
  clipboard = common.apps.clipboard;
  swayConfigPath = "${config.xdg.configHome}/sway/config";

  # 3. Sử dụng bemenu từ common config
  menu = common.menu;

  # 4. Danh sách Workspace (1-9 và 0)
  wsKeys = map (n: toString n) [ 1 2 3 4 5 6 ];

  # 5. Swaylock command
  swaylock = pkgs.swaylock-effects;
  lockCmd = "${swaylock}/bin/swaylock -f"
    + " --screenshot"
    + " --color ${p.base00}"
    + " --effect-blur 7x5 --effect-vignette 0.5:0.5 --fade-in 0.2"
    + " --inside-color ${p.base01}"
    + " --inside-clear-color ${p.base0C}"
    + " --inside-ver-color ${p.base0D}"
    + " --inside-wrong-color ${p.base08}"
    + " --ring-color ${p.base0D}"
    + " --ring-clear-color ${p.base0C}"
    + " --ring-ver-color ${p.base0D}"
    + " --ring-wrong-color ${p.base08}"
    + " --key-hl-color ${p.base0B}"
    + " --bs-hl-color ${p.base08}"
    + " --separator-color ${p.base01}"
    + " --text-color ${p.base05}"
    + " --text-clear-color ${p.base01}"
    + " --text-ver-color ${p.base01}"
    + " --text-wrong-color ${p.base01}"
    + " --indicator-radius 100 --indicator-thickness 10";
  powerOffMonitors = pkgs.writeShellScript "wm-power-off-monitors" ''
    if [ -n "''${NIRI_SOCKET:-}" ]; then
      ${pkgs.niri}/bin/niri msg action power-off-monitors && exit 0
    fi

    if [ -n "''${SWAYSOCK:-}" ]; then
      ${pkgs.sway}/bin/swaymsg 'output * power off' && exit 0
    fi
  '';
  powerOnMonitors = pkgs.writeShellScript "wm-power-on-monitors" ''
    if [ -n "''${NIRI_SOCKET:-}" ]; then
      ${pkgs.niri}/bin/niri msg action power-on-monitors && exit 0
    fi

    if [ -n "''${SWAYSOCK:-}" ]; then
      ${pkgs.sway}/bin/swaymsg 'output * power on' && exit 0
    fi
  '';
in
{
  # Sway-related packages
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "tmux-pick" ''
      sessions=$(tmux list-sessions -F "#{session_name}: #{session_windows} windows [#{session_attached} attached]" 2>/dev/null)
      if [ -z "$sessions" ]; then
        notify-send "tmux" "No sessions running"
        exit 0
      fi
      picked=$(echo "$sessions" | rofi -dmenu -p " Tmux")
      [ -z "$picked" ] && exit 0
      session_name=$(echo "$picked" | cut -d: -f1)
      if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
      elif [ -n "$KITTY_WINDOW_ID" ]; then
        tmux attach-session -t "$session_name"
      else
        sent=0
        for sock in /tmp/kitty-*; do
          [ -S "$sock" ] || continue
          if kitty @ --to "unix:$sock" send-text --match=state:focused "tmux attach-session -t $session_name\n" 2>/dev/null; then
            sent=1
            break
          fi
        done
        [ "$sent" -eq 0 ] && kitty -e tmux attach-session -t "$session_name"
      fi
    '')

    # Sway utilities
    swaybg # Wallpaper
    swaylock-effects # Screen locker with effects (blur, fade, etc.)
    swayidle # Idle management
    autotiling # Auto tiling
    swayr # Window switcher / tiled scratchpad

    # Wayland utilities
    waybar # Status bar
    wl-clipboard # Clipboard manager
    cliphist # Clipboard history
    grim # Screenshot tool
    slurp # Region selector
    mako # Notification daemon
    libnotify # notify-send command

    # Portals (already enabled in system, but needed for runtime)
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  wayland.windowManager.sway = {
    enable = true;
    # wrapperFeatures and xwayland are handled by the system-level sway module

    config = {
      modifier = modifier;
      terminal = terminal;
      menu = menu;

      fonts = {
        names = [ fonts.ui ];
        size = 11.0;
      };

      gaps = {
        inner = 2;
        outer = 2;
      };

      # Resize by percentage points instead of the default fixed px step,
      # so it scales with output size (both tiled and floating windows).
      modes.resize = {
        "Left" = "resize shrink width 5 ppt";
        "Down" = "resize grow height 5 ppt";
        "Up" = "resize shrink height 5 ppt";
        "Right" = "resize grow width 5 ppt";
        "h" = "resize shrink width 5 ppt";
        "j" = "resize grow height 5 ppt";
        "k" = "resize shrink height 5 ppt";
        "l" = "resize grow width 5 ppt";
        "Escape" = "mode default";
        "Return" = "mode default";
      };

      window.commands = [
        {
          command = "floating enable";
          criteria = { app_id = "yad"; };
        }
        {
          command = "floating enable, move position center, resize set 600 400";
          criteria = { app_id = "org.pulseaudio.pavucontrol"; };
        }
        {
          command = "floating enable, move position center, resize set 800 600";
          criteria = { app_id = "blueman-manager"; };
        }
        {
          command = "floating enable, resize set 400 300, move position 20px 100ppt, move up 320px";
          criteria = { app_id = "^(mpv)$"; };
        }
        {
          command = "exec fcitx5-remote -c";
          criteria = { app_id = "^(kitty|foot)$"; };
        }
      ];

      keybindings = lib.mkForce (
        {
          # Launchers
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+b" = "exec ${browser}";
          "${modifier}+y" = "exec nemo";
          "${modifier}+BackSpace" = "exec tmux-pick";

          # Utilities
          "${modifier}+v" = "exec ${clipboard}";
          "${modifier}+s" = "exec grim -g \"$(slurp)\" - | tee ~/Pictures/screenshots/shot_$(date +\"%Y-%m-%d-%H-%M-%S\").png | wl-copy && notify-send 'Screenshot saved' 'Region captured'";

          # Window Management
          "${modifier}+Shift+w" = "exec rofi -show window";
          "${modifier}+w" = "kill";
          "${modifier}+a" = "exec sticky enable";
          "${modifier}+t" = "floating toggle";
          "${modifier}+f" = "fullscreen";
          # "${modifier}+u" = "exec ~/.config/sway/scripts/tiling.sh";

          # Focus
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Split
          "${modifier}+semicolon" = "splith";
          "${modifier}+Shift+v" = "splitv";

          # Layout
          "${modifier}+e" = "layout toggle split";
          "${modifier}+Shift+s" = "layout stacking";
          "${modifier}+x" = "layout tabbed";

          # Focus parent/child
          "${modifier}+p" = "focus parent";

          # Scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          # Resize mode
          "${modifier}+r" = "mode resize";

          # System Controls
          "${modifier}+Shift+t" = "exec ${lockCmd}";
          "${modifier}+Shift+a" = "exec pkill -SIGUSR2 waybar";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut.' -B 'Yes, exit sway' 'swaymsg exit'";
          "ctrl+alt+delete" = "exec nwg-bar";

          # Media Keys
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";

        } //
        # Tự động tạo bindings cho Workspaces
        (builtins.listToAttrs (map
          (i: {
            name = "${modifier}+${i}";
            value = "workspace number ${i}";
          })
          wsKeys)) //
        (builtins.listToAttrs (map
          (i: {
            name = "${modifier}+Shift+${i}";
            value = "move container to workspace number ${i}";
          })
          wsKeys))
      );

      colors = {
        focused = {
          border = c.base0D;
          background = c.base01;
          text = c.base05;
          indicator = c.base0C;
          childBorder = c.base0D;
        };
        unfocused = {
          border = c.base00;
          background = c.base01;
          text = c.base03;
          indicator = c.base00;
          childBorder = c.base01;
        };
      };

      bars = [ ];

      startup = [
        { command = "autotiling -l 2"; always = true; }
        { command = "sh -c 'pkill -x swayrd; exec swayrd'"; always = true; }
        # Import Wayland env vars vào systemd user session, sau đó restart kanshi
        { command = "sh -c 'dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK XDG_SESSION_TYPE && systemctl --user restart kanshi.service swayidle.service waybar.service'"; always = false; }
      ] ++ common.startupPrograms;
    };

    extraConfig = ''
      default_border pixel 2

      # --no-repeat: giữ phím không dội hàng loạt lệnh khi held
      bindsym --no-repeat ${modifier}+Tab exec swayr next-window all-workspaces
      bindsym --no-repeat ${modifier}+Shift+Tab exec swayr prev-window all-workspaces
    '';
  };

  xdg.configFile."swayfx/config".text = ''
    include ${swayConfigPath}

    # SwayFX-only visual effects layered on top of the shared Sway config.
    corner_radius 4
    default_dim_inactive 0.06

    shadows enable
    shadow_blur_radius 12
    shadow_color ${c.base00}88

    blur enable
    blur_radius 6
    blur_passes 3
    blur_xray false
  '';

  xdg.configFile."swayr/config.toml".text = ''
    [menu]
    executable = "rofi"
    args = ["-dmenu", "-p", "swayr"]
  '';

  xdg.configFile."scroll/config".text = ''
    include ${swayConfigPath}

    # Keep Scroll plain like vanilla Sway: no rounded corners/shadow/dim and no animations.
    default_decoration border_radius 0 shadow false dim false
    animations {
      enabled no
    }

    # Pin new windows to the edge instead of centering them when they fit the viewport.
    center_horizontal_if_fits false
    center_vertical_if_fits false
  '';

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = lockCmd;
    };
    timeouts = [
      {
        timeout = 300;
        command = lockCmd;
      }
      {
        timeout = 600;
        command = "${powerOffMonitors}";
        resumeCommand = "${powerOnMonitors}";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    package = swaylock;
    settings = {
      color = p.base00;
      ignore-empty-password = true;
      indicator-radius = 120;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;
    };
  };

}
