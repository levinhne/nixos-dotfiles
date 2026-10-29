{ ... }:

{
  security.rtkit.enable = true;

  # Polkit authentication agent for Sway/Niri (neither ships one), so GUI apps
  # like nemo can prompt for a password; runs as a graphical-session user service.
  security.soteria.enable = true;
}
