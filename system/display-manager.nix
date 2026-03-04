{ config, pkgs, ... }:

let
  # Tạo thư mục chứa cả Sway và Niri sessions
  waylandSessions = pkgs.runCommand "wayland-sessions" { } ''
    mkdir -p $out/share/wayland-sessions
    ln -s ${pkgs.sway}/share/wayland-sessions/sway.desktop $out/share/wayland-sessions/
    ln -s ${pkgs.niri}/share/wayland-sessions/niri.desktop $out/share/wayland-sessions/
  '';
in
{
  # Display manager: Ly (minimal TUI display manager)
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "doom";
      # Wayland sessions (cả Sway và Niri)
      waylandsessions = "${waylandSessions}/share/wayland-sessions";
    };
  };
}
