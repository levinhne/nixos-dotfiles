{ config, pkgs, lib, pkgs-unstable, ... }:

{
  options = {
    mySystem.extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages to install";
    };
  };
  config = {
    environment.systemPackages = (with pkgs; [
      # Core utilities
      vim
      nano
      git
      wget
      curl
      openssl

      nodejs_24

      # System monitoring
      htop
      btop
      fastfetch
      # Desktop apps

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
      inetutils
      lsof
    ])
    ++ [ pkgs.cloudflared ]
    ++ config.mySystem.extraPackages;
  };
}

