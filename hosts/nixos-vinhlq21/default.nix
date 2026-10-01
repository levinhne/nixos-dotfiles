{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/base.nix
    ../common/desktop.nix
    ./cloudflared.nix
    ./office.nix
  ];

  system.stateVersion = "25.11";
}
