{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
  ];

  system.stateVersion = "25.11";
}
