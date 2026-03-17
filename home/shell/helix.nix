{ pkgs, lib, theme, fonts, ... }:

let
  helixThemeName = "base16-dracula-sync";
in
{
  home.packages = with pkgs; [
    gopls
    golangci-lint-langserver
    go
    nixd
    nixpkgs-fmt
    pyright
    black
    rust-analyzer
    rustfmt
  ];

  programs.helix = {
    enable = true;

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

        lsp = {
          display-messages = true;
        };
      };
    };

    languages = {
      language-server = {
        gopls = {
          command = lib.getExe pkgs.gopls;
        };

        golangci-lint-lsp = {
          command = lib.getExe pkgs.golangci-lint-langserver;
        };

        nixd = {
          command = lib.getExe pkgs.nixd;
        };

        pyright = {
          command = lib.getExe pkgs.pyright;
        };

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
        };
      };

      language = [
        {
          name = "go";
          auto-format = true;
          language-servers = [
            "gopls"
            "golangci-lint-lsp"
          ];
          formatter = {
            command = "${pkgs.go}/bin/gofmt";
          };
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter = {
            command = lib.getExe pkgs.nixpkgs-fmt;
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [ "pyright" ];
          formatter = {
            command = lib.getExe pkgs.black;
            args = [ "-" ];
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

      "ui.background" = {
        bg = theme.colors.base00;
      };

      "ui.text" = {
        fg = theme.colors.base05;
      };

      "ui.cursor" = {
        fg = theme.colors.base00;
        bg = theme.colors.base0D;
      };

      "ui.cursor.insert" = {
        fg = theme.colors.base00;
        bg = theme.colors.base0B;
      };

      "ui.cursor.select" = {
        fg = theme.colors.base00;
        bg = theme.colors.base0E;
      };

      "ui.selection" = {
        bg = theme.colors.base01;
      };

      "ui.cursorline.primary" = {
        bg = theme.colors.base01;
      };

      "ui.linenr" = {
        fg = theme.colors.base03;
      };

      "ui.linenr.selected" = {
        fg = theme.colors.base0A;
      };

      "ui.statusline" = {
        fg = theme.colors.base05;
        bg = theme.colors.base01;
      };

      "ui.statusline.insert" = {
        fg = theme.colors.base00;
        bg = theme.colors.base0B;
      };

      "ui.statusline.normal" = {
        fg = theme.colors.base00;
        bg = theme.colors.base0D;
      };

      "ui.statusline.select" = {
        fg = theme.colors.base00;
        bg = theme.colors.base0E;
      };

      "ui.virtual.indent-guide" = {
        fg = theme.colors.base01;
      };

      "ui.virtual.indent-guide.active" = {
        fg = theme.colors.base03;
      };
    };
  };

  # Helix inherits the terminal font from Foot/Kitty, keeping editor typography aligned.
  assertions = [
    {
      assertion = fonts ? terminal;
      message = "home/shell/helix.nix expects fonts.terminal from the profile module arguments.";
    }
  ];
}
