{ config, pkgs, ... }:

{
  # Disable X11 - use Wayland only
  services.xserver.enable = false;

  # Enable Sway window manager at system-level
  # This provides the necessary system permissions and setuid wrappers
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
    # Packages are installed via home-manager for per-user configuration
  };

  # XDG Portal for Wayland (screenshare, file picker, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
}
