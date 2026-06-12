{ pkgs, ... }:

{
  # Bật Bluetooth
  hardware.bluetooth.enable = true;

  # Bật Bluetooth khi khởi động máy
  hardware.bluetooth.powerOnBoot = true;

  # Trình quản lý Bluetooth GUI (kèm D-Bus service blueman-mechanism)
  services.blueman.enable = true;
}
