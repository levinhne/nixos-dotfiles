{ config, pkgs, username, ... }:

let
  hmSwayPackage = config.home-manager.users.${username}.wayland.windowManager.sway.package or pkgs.sway;

  # Tạo thư mục chứa cả Sway và Niri sessions
  waylandSessions = pkgs.runCommand "wayland-sessions" { } ''
    mkdir -p $out/share/wayland-sessions

    # Use the Home Manager Sway wrapper so user systemd session targets
    # like graphical-session.target are started correctly on login.
    cat > $out/share/wayland-sessions/sway.desktop <<EOF
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=${hmSwayPackage}/bin/sway
Type=Application
DesktopNames=sway
EOF

    ln -s ${pkgs.niri}/share/wayland-sessions/niri.desktop $out/share/wayland-sessions/
  '';
in
{
  # Display manager: Ly (minimal TUI display manager)
  services.displayManager.ly = {
    enable = true;
    settings = {
      # Wayland sessions (cả Sway và Niri)
      waylandsessions = "${waylandSessions}/share/wayland-sessions";
    };
  };
}
