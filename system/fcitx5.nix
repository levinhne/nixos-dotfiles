{ config, pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-unikey
      fcitx5-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    qt6Packages.fcitx5-configtool
  ];
}
