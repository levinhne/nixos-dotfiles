{ pkgs, ... }:

{
  # Bật Bluetooth
  hardware.bluetooth.enable = true;

  # Bật Bluetooth khi khởi động máy
  hardware.bluetooth.powerOnBoot = true;

  # Cài đặt trình quản lý Bluetooth
  environment.systemPackages = with pkgs; [
    blueman # Giao diện GUI cực tốt cho Sway/Wayland
  ];

  # Hỗ trợ âm thanh Bluetooth (A2DP) qua Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
