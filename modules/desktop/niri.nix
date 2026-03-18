{ config, pkgs, ... }:

{
  # Enable Niri window manager at system-level
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Disable GNOME's GCR SSH agent to avoid conflict with programs.ssh.startAgent
  services.gnome.gcr-ssh-agent.enable = false;

  # XDG Portal for Wayland
  # Portal config đã được thiết lập trong the system-level sway module
  # Nếu muốn thêm GNOME portal cho Niri, cần disable gcr-ssh-agent như trên
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome # Niri works well with GNOME portal
  ];

  # Enable XWayland support (có thể đã được enable trong sway.nix)
  programs.xwayland.enable = true;
}
