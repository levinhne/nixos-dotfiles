{ config, pkgs, lib, ... }:

{
  options = {
    mySystem.extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra packages to install";
    };
  };
  config = {
    environment.systemPackages = with pkgs; [
      # Core utilities
      vim
      nano
      git
      wget
      curl
      # System monitoring
      htop
      btop
      neofetch
      # Desktop apps
      firefox
      kitty
      # File management
      ranger
      unzip
      zip
      p7zip
      # Audio
      pulseaudio
      # Password management
      gopass
      age
      # GPG/PGP tools
      paperkey
      # Network tools
      cloudflared
    ] ++ config.mySystem.extraPackages;
  };
}

