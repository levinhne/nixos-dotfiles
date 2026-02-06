{ ... }:

{
  # Wofi (launcher)
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      allow_images = true;
      prompt = "Run:";
    };
    style = ''
      window { border-radius: 8px; }
    '';
  };
}
