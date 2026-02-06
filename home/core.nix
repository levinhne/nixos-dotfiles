{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Các config folders cần symlink từ dotfiles
  configs = {
    "nvim" = "nvim";
    "qutebrowser" = "qutebrowser";
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
}
