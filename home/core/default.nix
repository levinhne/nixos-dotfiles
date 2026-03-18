{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;

  retrosmart-cursors = pkgs.callPackage ../../packages/retrosmart-cursors.nix { };

  configs = {
    "qutebrowser" = "qutebrowser";
    "fcitx" = "fcitx";
    "fcitx5" = "fcitx5";
    "nvim" = "nvim";
  };
in
{
  home.stateVersion = "25.11";

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = createSymlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  programs.home-manager.enable = true;

  home.pointerCursor = {
    package = retrosmart-cursors;
    name = "retrosmart-xcursor-black";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "google-chrome-stable";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "fcitx";
  };
}
