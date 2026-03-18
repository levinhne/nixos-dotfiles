# Common shell configuration
# Contains shared secrets loading for API keys
{ ... }:

{
  # Secrets loading for Fish shell
  fishSecrets = ''
    if test -f /run/agenix/crush-openai
      set -gx OPENAI_API_KEY (cat /run/agenix/crush-openai)
    end
    if test -f /run/agenix/crush-fpt
      set -gx FPT_API_KEY (cat /run/agenix/crush-fpt)
    end
  '';

  fishRebuildFunction = ''
    set -l current_host (hostnamectl --static 2>/dev/null)
    if test -z "$current_host"
      set current_host (hostname)
    end

    sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$current_host $argv
  '';

  # Secrets loading for Bash shell
  bashSecrets = ''
    if [ -f /run/agenix/crush-openai ]; then
      export OPENAI_API_KEY="$(cat /run/agenix/crush-openai)"
    fi
    if [ -f /run/agenix/crush-fpt ]; then
      export FPT_API_KEY="$(cat /run/agenix/crush-fpt)"
    fi
  '';

  bashRebuildFunction = ''
    __nixos_rebuild_switch() {
      local current_host
      current_host="$(hostnamectl --static 2>/dev/null || hostname)"
      sudo nixos-rebuild switch --flake ~/nixos-dotfiles#"''${current_host}" "$@"
    }
  '';
}
