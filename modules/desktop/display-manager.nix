{ config, pkgs, username, inputs, ... }:

let
  hmSwayPackage = config.home-manager.users.${username}.wayland.windowManager.sway.package or pkgs.sway;
  swayfxPackage = pkgs.swayfx.override {
    isNixOS = true;
    withGtkWrapper = true;
    enableXWayland = true;
  };
  scrollPackage = inputs.scroll-flake.packages.${pkgs.system}.scroll-stable;

  # Tạo thư mục chứa Sway, SwayFX và Niri sessions
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

        cat > $out/share/wayland-sessions/swayfx.desktop <<EOF
    [Desktop Entry]
    Name=SwayFX
    Comment=Sway compositor with visual effects
    Exec=${swayfxPackage}/bin/sway -c /home/${username}/.config/swayfx/config
    Type=Application
    DesktopNames=swayfx
    EOF

        cat > $out/share/wayland-sessions/scroll.desktop <<EOF
    [Desktop Entry]
    Name=Scroll
    Comment=Sway fork with a PaperWM-style scrolling layout
    Exec=${scrollPackage}/bin/scroll -c /home/${username}/.config/scroll/config
    Type=Application
    DesktopNames=scroll
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
