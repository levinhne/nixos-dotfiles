{ pkgs, theme, ... }:

{
  programs.starship = {
    enable = true;
    # Tự động kích hoạt cho Bash và Fish
    enableFishIntegration = true;
    enableBashIntegration = true;

    # Cấu hình giao diện (tùy chỉnh theo ý bạn)
    settings = {
      add_newline = false;
      line_break.disabled = true;
      character = {
        success_symbol = "[➜](bold ${theme.colors.base0B})";
        error_symbol = "[➜](bold ${theme.colors.base08})";
      }; # Hiển thị biểu tượng NixOS
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };
}
