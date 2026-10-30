{ ... }:

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

  # AIC 8800D80 (2604:0020) là combo Wi-Fi + BT dùng chung 1 thiết bị USB, BT hay
  # bị đứt (link tx timeout) khi Wi-Fi chạy. Chỉ tắt các interface BT (class e0),
  # giữ nguyên interface Wi-Fi (class ff) và dùng dongle USB Bluetooth rời thay thế.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_interface", \
      ATTRS{idVendor}=="2604", ATTRS{idProduct}=="0020", ATTR{bInterfaceClass}=="e0", \
      ATTR{authorized}="0"
  '';
}
