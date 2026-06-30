{ hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
    ../../modules/services/k3s.nix
  ];

  networking.hostName = hostname;

  system.stateVersion = "25.11";
}
