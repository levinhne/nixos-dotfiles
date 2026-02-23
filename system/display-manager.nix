{ config, pkgs, ... }:

{
  # Display manager: Ly (minimal TUI display manager)
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "doom";
      # Wayland session
      waylandsessions = "${pkgs.sway}/share/wayland-sessions";
    };
  };
}
