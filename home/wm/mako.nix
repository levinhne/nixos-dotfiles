{ theme, ... }:

{
  # Mako (notifications)
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      background-color = theme.colors.base00;
      text-color = theme.colors.base05;
      border-color = theme.colors.base0D;

      font = "monospace 8";
    };
  };
}
