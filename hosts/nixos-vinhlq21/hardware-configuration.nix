# Hardware configuration for nixos-vinhlq21 (Work laptop)
# 
# IMPORTANT: This is a template. After installing NixOS, run
# `sudo nixos-generate-config`, then copy the generated hardware module here.
#
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot modules - adjust based on your hardware
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];

  # CPU - change to kvm-amd if using AMD processor
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # File systems are managed by disko.nix
  fileSystems = { };
  swapDevices = [ ];

  # Platform and CPU microcode
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # If using AMD, uncomment this and remove the Intel line above:
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
