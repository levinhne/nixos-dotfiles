{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/boot.nix
    ../../system/fonts.nix
    ../../system/core.nix
    ../../system/bluetooth.nix
    ../../system/ssh.nix
    ../../system/audio.nix
    ../../system/sway.nix
    ../../system/niri.nix
    ../../system/display-manager.nix
    ../../system/graphics.nix
    ../../system/packages.nix
    ../../system/user.nix
    ../../system/secrets.nix
    ../../system/office.nix
    ../../home/fcitx5.nix
    ./cloudflared.nix
  ];

  # Network
  networking.hostName = "nixos-levinhne";
  networking.networkmanager.enable = true;

  system.stateVersion = "25.11";
}
