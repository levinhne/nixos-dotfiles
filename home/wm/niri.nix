{ pkgs, lib, fonts, theme, ... }:

let
  kanshi = import ./kanshi.nix { inherit pkgs; };
in

let
  # Các biến cấu hình chung
  terminal = "kitty";

  # Bảng màu từ theme
  c = theme.colors;

  # Cấu hình bemenu (sử dụng lại từ sway)
  menu = "bemenu-run " +
    "--fn '${fonts.ui} 10.3' " +
    "--tb '${c.base00}' --tf '${c.base0D}' " +
    "--fb '${c.base00}' --ff '${c.base05}' " +
    "--nb '${c.base00}' --nf '${c.base05}' " +
    "--hb '${c.base01}' --hf '${c.base0B}' " +
    "--cb '${c.base0D}' --cf '${c.base00}' " +
    "--sb '${c.base01}' --sf '${c.base0E}' " +
    "--ab '${c.base00}' --af '${c.base0C}' " +
    "--fbb '${c.base00}' --fbf '${c.base0C}' " +
    "--scb '${c.base00}' --scf '${c.base0C}' " +
    "--bdr '${c.base0D}' " +
    "-c -B 2 -W 0.5 -H 28 --hp 10 --prompt 'Run:'";

  # Niri config file in KDL format
  niriConfig = ''
    // Environment variables for Input Method
    environment {
        GTK_IM_MODULE "fcitx"
        QT_IM_MODULE "fcitx"
        XMODIFIERS "@im=fcitx"
        GLFW_IM_MODULE "fcitx"
    }

    // Input configuration
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        
        touchpad {
            tap
            natural-scroll
        }
    }

    // Output configuration
    output "HDMI-A-1" {
        mode "1920x1200@60.000"
        position x=0 y=0
    }

    // Layout configuration
    layout {
        gaps 4
        
        focus-ring {
            width 2
            active-color "${c.base0D}"
            inactive-color "${c.base01}"
        }
        
        border {
            width 2
            active-color "${c.base0D}"
            inactive-color "${c.base01}"
        }
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }
        
        default-column-width { proportion 0.5; }
        
        center-focused-column "never"
    }

    // Cursor
    cursor {
        xcursor-theme "retrosmart-xcursor-black"
        xcursor-size 24
    }

    prefer-no-csd

    screenshot-path "~/Pictures/screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png"

    // Keybindings
    binds {
        // Launchers
        Mod+Return { spawn "${terminal}"; }
        Mod+D { spawn "sh" "-c" "${menu}"; }
        Mod+B { spawn "google-chrome-stable"; }
        Mod+Y { spawn "nemo"; }

        // Window Management
        Mod+W { close-window; }
        Mod+F { fullscreen-window; }
        
        // Lock screen
        Mod+Shift+T { spawn "swaylock" "--screenshots" "--effect-blur" "7x5" "--effect-vignette" "0.5:0.5" "--fade-in" "0.2" "--color" "${c.base00}" "--indicator-radius" "100" "--font" "${fonts.ui}"; }

        // Clipboard
        Mod+V { spawn "sh" "-c" "cliphist list | bemenu -p 'Clipboard' | cliphist decode | wl-copy"; }

        // Screenshots
        Mod+S { spawn "sh" "-c" "grim -g \"$(slurp)\" - | tee ~/Pictures/screenshots/shot_$(date +\"%Y-%m-%d-%H-%M-%S\").png | wl-copy && notify-send 'Screenshot saved' 'Region captured'"; }
        Mod+Shift+S { spawn "sh" "-c" "grim - | tee ~/Pictures/screenshots/shot_$(date +\"%Y-%m-%d-%H-%M-%S\").png | wl-copy && notify-send 'Screenshot saved' 'Full screen captured'"; }

        // Focus
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }

        // Move
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }

        // Move to workspace
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }

        // Column width adjustment
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+R { switch-preset-column-width; }  // Cycle: 33% -> 50% -> 66% -> 100% -> 33% ...

        // Quit
        Mod+Shift+E { quit; }

        // Media keys
        XF86AudioMute { spawn "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"; }
        XF86AudioLowerVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%"; }
        XF86AudioRaiseVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
    }

    // Window rules
    window-rule {
        match app-id="^yad$"
        default-column-width { proportion 0.3; }
    }

    window-rule {
        match app-id="^org\\.pulseaudio\\.pavucontrol$"
        default-column-width { fixed 600; }
    }

    // Startup programs
    spawn-at-startup "waybar"
    spawn-at-startup "wpaperd" "-d"
    spawn-at-startup "mako"
    spawn-at-startup "fcitx5" "-d"
    spawn-at-startup "sh" "-c" "wl-paste --type text --watch cliphist store"
    spawn-at-startup "blueman-applet"

    // Animations
    animations {
        slowdown 1.0
        
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        
        window-close {
            duration-ms 150
            curve "ease-out-expo"
        }
        
        config-notification-open-close {
            spring damping-ratio=0.6 stiffness=1000 epsilon=0.001
        }
    }
  '';
in
{
  # Import kanshi configuration
  imports = [ kanshi ];

  # Tạo file config cho Niri
  xdg.configFile."niri/config.kdl".text = niriConfig;
}
