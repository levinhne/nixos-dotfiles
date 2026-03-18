# Tmux configuration with Dracula theme
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-refresh-rate 10
        '';
      }
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*:RGB"
      set -g set-clipboard on
      set -g pane-border-status top
      set -g pane-border-format "  #{pane_index} #{pane_current_command}  "

      # Vim like pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      unbind %
      bind | split-window -h -c "#{pane_current_path}"

      unbind '"'
      bind - split-window -v -c "#{pane_current_path}"

      unbind r
      bind r source-file $HOME/.config/tmux/tmux.conf

      # Pane base index
      # set -g pane-base-index 1
      # set-window-option -g pane-base-index 1

      # Vim-like copy/paste
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Alt+hjkl to switch panes (vim-style)
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # Alt+number to select window
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9
    '';
  };
}
