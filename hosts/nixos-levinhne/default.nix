{ hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
  ];

  networking.hostName = hostname;

  system.stateVersion = "25.11";
}
