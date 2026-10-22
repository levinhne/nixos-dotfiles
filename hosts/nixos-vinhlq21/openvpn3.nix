{ ... }:

{
  # OpenVPN 3 Linux client (D-Bus services + `openvpn3` CLI)
  programs.openvpn3.enable = true;

  # openvpn3-service-netcfg treats any `systemd_resolved` key in netcfg.json as
  # enabled (even `false`), then dies when org.freedesktop.resolve1 is missing
  # ("New tunnel did not respond"). Running resolved also gives proper split DNS
  # for the VPN; NetworkManager hands its DNS to resolved automatically.
  services.resolved.enable = true;
}
