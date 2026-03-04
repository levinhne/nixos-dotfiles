{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Custom packages
  retrosmart-cursors = pkgs.callPackage ../packages/retrosmart-cursors.nix { };

  # Các config folders cần symlink từ dotfiles
  configs = {
    "qutebrowser" = "qutebrowser";
    "fcitx" = "fcitx";
    "fcitx5" = "fcitx5";
    "nvim" = "nvim";
  };
in
{
  home.username = "levinhne";
  home.homeDirectory = "/home/levinhne";
  home.stateVersion = "25.11";

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  programs.home-manager.enable = true;

  # Cursor theme configuration
  home.pointerCursor = {
    package = retrosmart-cursors;
    name = "retrosmart-xcursor-black";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    # Environment variables
    EDITOR = "nvim";
    BROWSER = "google-chrome-stable";

    # Fcitx5 - Input Method
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "fcitx"; # For apps using GLFW
  };
}
