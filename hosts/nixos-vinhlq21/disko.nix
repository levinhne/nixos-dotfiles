# Disk configuration for nixos-vinhlq21 (Work laptop)
#
# IMPORTANT: Adjust the device path and sizes based on your hardware.
# Current settings:
#   - Device: /dev/nvme0n1 (change if different)
#   - Boot: 1GB
#   - Swap: 16GB
#   - Root: Remaining space with btrfs subvolumes
#
{ ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      # TODO: Adjust device path for work laptop (check with `lsblk`)
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            size = "16G";
            content = {
              type = "swap";
              extraArgs = [ "-L" "swap" ];
              discardPolicy = "both";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "nixos" "-f" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
