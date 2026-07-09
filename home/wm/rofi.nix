{ config, pkgs, fonts, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
  p = config.lib.stylix.colors;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = false;
      drun-display-format = "{name}";
      display-drun = " Apps";
      display-run = " Run";
      kb-primary-paste = "ctrl+v";
      kb-secondary-paste = "ctrl+shift+v";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#${p.base00}";
        bg-alt = mkLiteral "#${p.base01}";
        fg = mkLiteral "#${p.base05}";
        fg-alt = mkLiteral "#${p.base03}";
        accent = mkLiteral "#${p.base0D}";
        urgent = mkLiteral "#${p.base08}";
        selected = mkLiteral "#${p.base0B}";
        border-color = mkLiteral "#${p.base0D}";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
      };

      "window" = {
        background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        border-color = mkLiteral "@border-color";
        border-radius = mkLiteral "8px";
        width = mkLiteral "600px";
        padding = mkLiteral "12px";
      };

      "mainbox" = {
        background-color = mkLiteral "transparent";
        children = mkLiteral "[inputbar, listview]";
        spacing = mkLiteral "8px";
      };

      "inputbar" = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "6px";
        padding = mkLiteral "8px 12px";
        children = mkLiteral "[prompt, entry]";
        spacing = mkLiteral "8px";
      };

      "prompt" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent";
        font = "${fonts.ui} 11";
      };

      "entry" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        placeholder-color = mkLiteral "@fg-alt";
        placeholder = "Search...";
        font = "${fonts.ui} 11";
      };

      "listview" = {
        background-color = mkLiteral "transparent";
        lines = 8;
        columns = 1;
        spacing = mkLiteral "4px";
        scrollbar = false;
      };

      "element" = {
        background-color = mkLiteral "transparent";
        border-radius = mkLiteral "6px";
        padding = mkLiteral "6px 10px";
        spacing = mkLiteral "10px";
        orientation = mkLiteral "horizontal";
      };

      "element selected" = {
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@selected";
      };

      "element urgent" = {
        text-color = mkLiteral "@urgent";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        font = "${fonts.ui} 11";
        vertical-align = mkLiteral "0.5";
      };

      "mode-switcher" = {
        background-color = mkLiteral "transparent";
        spacing = mkLiteral "4px";
      };

      "button" = {
        background-color = mkLiteral "@bg-alt";
        border-radius = mkLiteral "6px";
        padding = mkLiteral "4px 10px";
        text-color = mkLiteral "@fg-alt";
      };

      "button selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg";
      };
    };
  };
}
