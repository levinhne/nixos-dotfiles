{ config, lib, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
in
{
  home.stateVersion = "26.05";

  home.activation.linkDotfileConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for name in qutebrowser fcitx fcitx5; do
      ln -sfn "${dotfiles}/$name" "${config.xdg.configHome}/$name"
    done
  '';

  programs.home-manager.enable = true;

  home.pointerCursor = {
    package = pkgs.retrosmart-cursors;
    name = "retrosmart-xcursor-black";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "google-chrome-stable";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "fcitx";
  };
}
