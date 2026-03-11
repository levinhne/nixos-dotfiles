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

  # Secrets loading for Bash shell
  bashSecrets = ''
    if [ -f /run/agenix/crush-openai ]; then
      export OPENAI_API_KEY="$(cat /run/agenix/crush-openai)"
    fi
    if [ -f /run/agenix/crush-fpt ]; then
      export FPT_API_KEY="$(cat /run/agenix/crush-fpt)"
    fi
  '';
}
