{ ... }:

let
  shellCommon = import ./common.nix { };
in
{
  # Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne";
      clean = "sudo nix-collect-garbage -d";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };
    bashrcExtra = ''
    '';
  };
}
