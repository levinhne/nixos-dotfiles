{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
  ];

  networking.hostName = "nixos-levinhne";

  system.stateVersion = "25.11";
}
