{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
  ];

  networking.hostName = "nixos-vinhlq21";

  system.stateVersion = "25.11";
}
