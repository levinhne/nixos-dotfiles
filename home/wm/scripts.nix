# Helper scripts shared by Sway and Niri keybindings
{ pkgs, ... }:

{
  home.packages = [
    # Mod+BackSpace: pick a tmux session via rofi and attach it in kitty
    (pkgs.writeShellScriptBin "tmux-pick" ''
      sessions=$(tmux list-sessions -F "#{session_name}: #{session_windows} windows [#{session_attached} attached]" 2>/dev/null)
      if [ -z "$sessions" ]; then
        notify-send "tmux" "No sessions running"
        exit 0
      fi
      picked=$(echo "$sessions" | rofi -dmenu -p " Tmux")
      [ -z "$picked" ] && exit 0
      session_name=$(echo "$picked" | cut -d: -f1)
      if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
      elif [ -n "$KITTY_WINDOW_ID" ]; then
        tmux attach-session -t "$session_name"
      else
        sent=0
        for sock in /tmp/kitty-*; do
          [ -S "$sock" ] || continue
          if kitty @ --to "unix:$sock" send-text --match=state:focused "tmux attach-session -t $session_name\n" 2>/dev/null; then
            sent=1
            break
          fi
        done
        [ "$sent" -eq 0 ] && kitty -e tmux attach-session -t "$session_name"
      fi
    '')
  ];
}
