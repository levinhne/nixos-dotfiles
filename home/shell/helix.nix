{ lib, pkgs, config, fonts, ... }:

let
  p = config.colorScheme.palette;
  c = builtins.mapAttrs (_: v: "#${v}") p;
  helixThemeName = "base16-sync";
in
{
  assertions = [
    {
      assertion = fonts ? terminal;
      message = "home/shell/helix.nix expects fonts.terminal from the profile module arguments.";
    }
  ];

  programs.helix = {
    enable = true;
    defaultEditor = false;

    extraPackages = with pkgs; [
      go
      gopls
      golangci-lint-langserver
      nixd
      nixpkgs-fmt
      pyright
      black
      rust-analyzer
      rustfmt
    ];

    settings = {
      theme = helixThemeName;

      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "multiple";
        color-modes = true;

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "|";
        };

        lsp.display-messages = true;
      };
    };

    languages = {
      language-server = {
        gopls.command = lib.getExe pkgs.gopls;

        golangci-lint-lsp.command = lib.getExe pkgs.golangci-lint-langserver;

        nixd.command = lib.getExe pkgs.nixd;

        pyright = {
          command = lib.getExe' pkgs.pyright "pyright-langserver";
          args = [ "--stdio" ];
        };

        rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
      };

      language = [
        {
          name = "go";
          auto-format = true;
          language-servers = [
            "gopls"
            "golangci-lint-lsp"
          ];
          formatter.command = lib.getExe' pkgs.go "gofmt";
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter.command = lib.getExe pkgs.nixpkgs-fmt;
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [ "pyright" ];
          formatter = {
            command = lib.getExe pkgs.black;
            args = [ "-q" "-" ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
          formatter = {
            command = lib.getExe pkgs.rustfmt;
            args = [ "--emit=stdout" ];
          };
        }
      ];
    };

    themes.${helixThemeName} = {
      inherits = "dracula";

      "ui.background" = { bg = c.base00; };
      "ui.text" = { fg = c.base05; };
      "ui.cursor" = {
        fg = c.base00;
        bg = c.base0D;
      };
      "ui.cursor.insert" = {
        fg = c.base00;
        bg = c.base0B;
      };
      "ui.cursor.select" = {
        fg = c.base00;
        bg = c.base0E;
      };
      "ui.selection" = { bg = c.base01; };
      "ui.cursorline.primary" = { bg = c.base01; };
      "ui.linenr" = { fg = c.base03; };
      "ui.linenr.selected" = { fg = c.base0A; };
      "ui.statusline" = {
        fg = c.base05;
        bg = c.base01;
      };
      "ui.statusline.insert" = {
        fg = c.base00;
        bg = c.base0B;
      };
      "ui.statusline.normal" = {
        fg = c.base00;
        bg = c.base0D;
      };
      "ui.statusline.select" = {
        fg = c.base00;
        bg = c.base0E;
      };
      "ui.virtual.indent-guide" = { fg = c.base01; };
      "ui.virtual.indent-guide.active" = { fg = c.base03; };
    };
  };
}
