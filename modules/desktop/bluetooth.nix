{ pkgs, ... }:

{
  # Bật Bluetooth
  hardware.bluetooth.enable = true;

  # Bật Bluetooth khi khởi động máy
  hardware.bluetooth.powerOnBoot = true;

  # Bật tính năng thử nghiệm của BlueZ: hiển thị % pin tai nghe (BatteryProvider)
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  # Trình quản lý Bluetooth GUI (kèm D-Bus service blueman-mechanism)
  services.blueman.enable = true;
}
