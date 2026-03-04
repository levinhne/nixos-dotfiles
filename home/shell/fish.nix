{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      if test -f /run/agenix/crush-openai
        set -gx OPENAI_API_KEY (cat /run/agenix/crush-openai)
      end
      if test -f /run/agenix/crush-fpt
        set -gx FPT_API_KEY (cat /run/agenix/crush-fpt)
      end
      direnv hook fish | source
    '';
    plugins = [
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne";
      v = "nvim";
    };
  };
}
