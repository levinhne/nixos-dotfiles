# Common shell configuration shared across Fish, Bash, and Zsh
{ ... }:

let
  secretFiles = [
  ];

  fishSecretLine = secret: ''
    if test -f ${secret.path}
      set -gx ${secret.env} (cat ${secret.path})
    end
  '';

  posixSecretLine = secret: ''
    if [ -f ${secret.path} ]; then
      export ${secret.env}="$(cat ${secret.path})"
    fi
  '';
in
{
  # Aliases shared across all shells (fish, bash, zsh)
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    ll = "ls -la";
    v = "nvim";
    clean = "sudo nix-collect-garbage -d";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
  };

  # Extra aliases for posix shells (bash, zsh) — call the shell functions defined via *InteractiveInit
  posixShellAliases = {
    update = "__nixos_rebuild_switch";
    nrs-host = "__nixos_rebuild_host";
  };

  fishSecrets = builtins.concatStringsSep "\n" (map fishSecretLine secretFiles);
  posixSecrets = builtins.concatStringsSep "\n" (map posixSecretLine secretFiles);

  fishRebuildFunction = ''
    set -l current_host (hostnamectl --static 2>/dev/null)
    if test -z "$current_host"
      set current_host (hostname)
    end

    sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$current_host $argv
  '';

  fishRebuildHostFunction = ''
    if test (count $argv) -eq 0
      echo "Usage: nrs-host <hostname>"
      return 1
    end
    sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$argv[1] $argv[2..-1]
  '';

  posixRebuildFunction = ''
    __nixos_rebuild_switch() {
      local current_host
      current_host="$(hostnamectl --static 2>/dev/null || hostname)"
      sudo nixos-rebuild switch --flake ~/nixos-dotfiles#"''${current_host}" "$@"
    }
  '';

  posixRebuildHostFunction = ''
    __nixos_rebuild_host() {
      if [ $# -eq 0 ]; then
        echo "Usage: nrs-host <hostname>"
        return 1
      fi
      local hostname="$1"
      shift
      sudo nixos-rebuild switch --flake ~/nixos-dotfiles#"''${hostname}" "$@"
    }
  '';

  fishInteractiveInit = ''
    set -gx DIRENV_LOG_FORMAT ""
    zoxide init fish | source
  '';

  bashInteractiveInit = ''
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    export HISTCONTROL=ignoreboth:erasedups
    export DIRENV_LOG_FORMAT=

    bind 'set completion-ignore-case on'
    bind 'set show-all-if-ambiguous on'
    bind 'TAB:menu-complete'

    eval "$(direnv hook bash)"
    eval "$(zoxide init bash)"
  '';

  zshInteractiveInit = ''
    export DIRENV_LOG_FORMAT=

    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' menu select

    eval "$(direnv hook zsh)"
    eval "$(zoxide init zsh)"
  '';
}
