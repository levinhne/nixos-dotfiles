{ ... }:

{
  # Mako (notifications)
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      background-color = "#333333";
      text-color = "#ffffff";
      border-color = "#88c0d0";

      font = "monospace 9";
    };
  };
}
