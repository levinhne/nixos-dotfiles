{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # cursorTheme = {
    #   name = "retrosmart-xcursor-black-color";
    #   size = 24;
    #   # Lưu ý: Nếu cursor này không có trong nixpkgs, bạn cần thêm package thủ công
    # };
    font = {
      name = "Noto Sans";
      size = 9;
    };
    gtk3.extraConfig = {
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 0;
      gtk-menu-images = 0;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = 0;
    };
  };

  # Đảm bảo font Noto Sans có sẵn
  home.packages = [ pkgs.noto-fonts ];
}
