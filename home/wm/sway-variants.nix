# SwayFX / Scroll sessions: both include the main Sway config and layer their own tweaks.
# Sessions are registered in modules/desktop/display-manager.nix.
{ config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
  swayConfigPath = "${config.xdg.configHome}/sway/config";
in
{
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

    # Same width presets as niri, allowing columns wider than the viewport (up to 200%).
    layout_widths [0.33333333 0.5 0.666666667 1.0 1.5 2.0]
    mouse_resize_tiling_limit false
    bindsym Mod4+Shift+r cycle_size h next
    bindsym Mod4+Ctrl+r cycle_size h prev
  '';
}
