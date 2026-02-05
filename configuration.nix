{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "nixos-levinhne";
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # KHÔNG bật X11
  services.xserver.enable = false;

  # Wayland/Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;    # GTK env vars
    xwayland.enable = true;        # Chạy app X11 qua XWayland
    extraPackages = with pkgs; [
      swaybg
      swaylock
      swayidle
      waybar
      wofi
      wl-clipboard
      cliphist
      grim
      slurp
      mako
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Display manager: greetd + tuigreet (Wayland-native)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # Âm thanh với PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Portal cho Wayland (screenshare, mở file, v.v.)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  # Đồ họa (tăng tương thích Wayland/wlroots)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # User
  users.users.levinhne = {
    isNormalUser = true;
    description = "Le Vinh Ne";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim nano git wget curl htop btop neofetch
    firefox
    kitty
    ranger
    unzip zip p7zip
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # KHÔNG ĐỔI sau khi cài!
  system.stateVersion = "25.11";
}
