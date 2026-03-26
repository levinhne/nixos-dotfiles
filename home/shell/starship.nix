{ pkgs, theme, ... }:

{
  programs.starship = {
    enable = true;
    # enableFishIntegration = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;

    settings = {
      add_newline = false;
      line_break.disabled = true;
      character = {
        success_symbol = "[λ](bold ${theme.colors.base0B})";
        error_symbol = "[λ](bold ${theme.colors.base08})";
      };
      python = {
        disabled = true;
      };
      package = {
        disabled = true;
      };
      nix_shell = {
        symbol = " ";
      };
      palette = "dracula";
      palettes.dracula = {
        background = theme.colors.base00;
        foreground = theme.colors.base05;
        current = theme.colors.base02;
        comment = theme.colors.base03;
        cyan = theme.colors.base0C;
        green = theme.colors.base0B;
        orange = theme.colors.base09;
        pink = theme.colors.base0E;
        purple = theme.colors.base0D;
        red = theme.colors.base08;
        yellow = theme.colors.base0A;
      };
    };
  };
}
