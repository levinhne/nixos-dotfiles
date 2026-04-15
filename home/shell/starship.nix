{ pkgs, config, ... }:

let
  p = config.lib.stylix.colors;
in
{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
      line_break.disabled = true;
      character = {
        success_symbol = "[λ](bold #${p.base0B})";
        error_symbol = "[λ](bold #${p.base08})";
      };
      python = {
        disabled = true;
      };
      package = {
        disabled = true;
      };
      nix_shell = {
        symbol = " ";
      };
      palette = "base16";
      palettes.base16 = {
        background = "#${p.base00}";
        foreground = "#${p.base05}";
        current = "#${p.base02}";
        comment = "#${p.base03}";
        cyan = "#${p.base0C}";
        green = "#${p.base0B}";
        orange = "#${p.base09}";
        pink = "#${p.base0E}";
        purple = "#${p.base0D}";
        red = "#${p.base08}";
        yellow = "#${p.base0A}";
      };
    };
  };
}
