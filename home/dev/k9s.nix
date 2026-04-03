{ ... }:

{
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          skin = "dracula";
        };
      };
    };
    skins = {
      dracula = {
        k9s = {
          body = {
            fgColor = "#f8f8f2";
            bgColor = "#282a36";
            logoColor = "#bd93f9";
          };
          prompt = {
            fgColor = "#f8f8f2";
            bgColor = "#282a36";
            suggestColor = "#6272a4";
          };
          info = {
            fgColor = "#ff79c6";
            sectionColor = "#f8f8f2";
          };
          dialog = {
            fgColor = "#f8f8f2";
            bgColor = "#282a36";
            buttonFgColor = "#f8f8f2";
            buttonBgColor = "#6272a4";
            buttonFocusFgColor = "#f1fa8c";
            buttonFocusBgColor = "#ff79c6";
            labelFgColor = "#ff79c6";
            fieldFgColor = "#f8f8f2";
          };
          frame = {
            border = {
              fgColor = "#6272a4";
              focusColor = "#44475a";
            };
            menu = {
              fgColor = "#f8f8f2";
              keyColor = "#ff79c6";
              numKeyColor = "#ff79c6";
            };
            crumbs = {
              fgColor = "#f8f8f2";
              bgColor = "#44475a";
              activeColor = "#44475a";
            };
            status = {
              newColor = "#50fa7b";
              modifyColor = "#8be9fd";
              addColor = "#50fa7b";
              pendingColor = "#f1fa8c";
              errorColor = "#ff5555";
              highlightColor = "#ff79c6";
              killColor = "#6272a4";
              completedColor = "#6272a4";
            };
            title = {
              fgColor = "#f8f8f2";
              bgColor = "#282a36";
              highlightColor = "#ffb86c";
              counterColor = "#bd93f9";
              filterColor = "#ff79c6";
            };
          };
          views = {
            charts = {
              defaultDialColors = [ "#bd93f9" "#ff5555" ];
              defaultChartColors = [ "#bd93f9" "#ff5555" ];
            };
            table = {
              fgColor = "#f8f8f2";
              bgColor = "#282a36";
              cursorFgColor = "#282a36";
              cursorBgColor = "#44475a";
              markColor = "#ff79c6";
              header = {
                fgColor = "#f8f8f2";
                bgColor = "#282a36";
                sorterColor = "#8be9fd";
              };
            };
            xray = {
              fgColor = "#f8f8f2";
              bgColor = "#282a36";
              cursorColor = "#44475a";
              graphicColor = "#bd93f9";
              showIcons = false;
            };
            yaml = {
              keyColor = "#ff79c6";
              colonColor = "#6272a4";
              valueColor = "#f8f8f2";
            };
            logs = {
              fgColor = "#f8f8f2";
              bgColor = "#282a36";
              indicator = {
                fgColor = "#f8f8f2";
                bgColor = "#bd93f9";
              };
            };
            help = {
              fgColor = "#f8f8f2";
              bgColor = "#282a36";
              sectionColor = "#50fa7b";
              keyColor = "#ff79c6";
              numKeyColor = "#ff79c6";
            };
          };
        };
      };
    };
  };
}
