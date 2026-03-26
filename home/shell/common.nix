# Common shell configuration shared across Fish, Bash, and Zsh
{ ... }:

let
  secretFiles = [
    {
      env = "OPENAI_API_KEY";
      path = "/run/agenix/crush-openai";
    }
    {
      env = "FPT_API_KEY";
      path = "/run/agenix/crush-fpt";
    }
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
  shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    ll = "ls -la";
    v = "nvim";
    update = "__nixos_rebuild_switch";
    clean = "sudo nix-collect-garbage -d";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
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

  posixRebuildFunction = ''
    __nixos_rebuild_switch() {
      local current_host
      current_host="$(hostnamectl --static 2>/dev/null || hostname)"
      sudo nixos-rebuild switch --flake ~/nixos-dotfiles#"''${current_host}" "$@"
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
