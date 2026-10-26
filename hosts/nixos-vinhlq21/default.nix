{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
    ./fcdclient.nix
    ./openvpn3.nix
  ];

  system.stateVersion = "25.11";
}
