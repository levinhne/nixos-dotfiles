{ ... }:

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
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      if [ -f /run/agenix/crush-openai ]; then
        export OPENAI_API_KEY="$(cat /run/agenix/crush-openai)"
      fi
      if [ -f /run/agenix/crush-fpt ]; then
        export FPT_API_KEY="$(cat /run/agenix/crush-fpt)"
      fi
      if command -v neofetch &> /dev/null; then neofetch; fi
    '';
  };
}
