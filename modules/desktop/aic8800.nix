{ config, pkgs, ... }:

{
  # USB WiFi Tenda AX900 (chip AICSemi AIC8800D80): driver ngoài kernel, build theo
  # boot.kernelPackages (packages/aic8800d80.nix)
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ../../packages/aic8800d80.nix { })
  ];

  # Mới cắm vào, thiết bị hiện ra dưới dạng ổ đĩa ảo chứa driver Windows (a69c:5725);
  # eject thì nó chuyển sang chế độ WiFi (a69c:8d80) và driver tự load
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ATTRS{idVendor}=="a69c", ATTRS{idProduct}=="5725", RUN+="${pkgs.util-linux}/bin/eject /dev/%k"
  '';
}
