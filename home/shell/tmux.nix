# Tmux configuration with Dracula theme
#
# Keys are chosen to not clash with nvim (NvChad), kitty and fish:
#   - Super      → window manager (niri/sway)
#   - Ctrl+Shift → kitty
#   - Alt        → tmux (no prefix), except NvChad's A-h/A-v/A-i terminals
#   - Ctrl+hjkl  → seamless pane/split navigation shared with nvim
#                  (vim-tmux-navigator on both sides)
#
# Alt (no prefix):
#   M-n new window      M-1..9 go to window   M-H/M-L prev/next window
#   M-Tab last window   M-\ split right       M-- split down
#   M-z zoom pane       M-x kill pane         M-y copy mode
#   M-w session/window tree
#
# Prefix (M-a) for rarer actions: H/J/K/L resize, r reload, C-l clear screen,
# d detach, , rename window, $ rename session, F tmux-fzf
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    mouse = true;
    prefix = "M-a";
    baseIndex = 1;
    keyMode = "vi";
    escapeTime = 10;
    focusEvents = true;
    historyLimit = 50000;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      resurrect
      tmux-fzf
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "cwd git time"

          set -g @dracula-show-left-icon "#h | #S"
          set -g @dracula-left-icon-padding 1
          set -g @dracula-show-flags true
          set -g @dracula-show-empty-plugins false

          set -g @dracula-show-powerline true
          set -g @dracula-show-edge-icons true
          set -g @dracula-show-left-sep "█"
          set -g @dracula-show-right-sep "█"
          set -g @dracula-inverse-divider "█"

          set -g @dracula-border-contrast true
          set -g @dracula-show-battery false
          set -g @dracula-refresh-rate 10

          set -g @dracula-cwd-max-dirs "3"
          set -g @dracula-cwd-max-chars "40"

          set -g @dracula-git-show-repo-name true
          set -g @dracula-git-disable-status false
          set -g @dracula-git-show-current-symbol "✓"
          set -g @dracula-git-show-diff-symbol "!"
          set -g @dracula-git-no-repo-message ""

          set -g @dracula-military-time true
          set -g @dracula-show-timezone false
          set -g @dracula-time-format "%F %R"
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore "on"
          set -g @continuum-save-interval "15"
        '';
      }
    ];

    extraConfig = ''
      # Truecolor + undercurl (nvim diagnostics) for kitty/foot
      set -as terminal-features ",*:RGB:usstyle"
      set -g set-clipboard on
      set -g allow-passthrough on

      # Forward modified keys (C-CR, C-, ...) so nvim/fish see them inside tmux
      set -as terminal-features ",xterm-kitty:extkeys,foot:extkeys"
      set -g extended-keys on
      set -g extended-keys-format csi-u

      set -g renumber-windows on

      # Name windows after the active pane's directory (follows cd)
      set -g automatic-rename on
      set -g automatic-rename-format "#{b:pane_current_path}"

      # --- Alt (no prefix) ---
      bind -n M-n new-window -c "#{pane_current_path}"
      bind -n M-H previous-window
      bind -n M-L next-window
      bind -n M-Tab last-window

      bind -n 'M-\' split-window -h -c "#{pane_current_path}"
      bind -n M-- split-window -v -c "#{pane_current_path}"
      bind -n M-z resize-pane -Z
      bind -n M-x confirm-before -p "kill-pane #P? (y/n)" kill-pane
      bind -n M-y copy-mode
      bind -n M-w choose-tree -Zw

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # --- Prefix ---
      bind c new-window -c "#{pane_current_path}"

      unbind %
      bind | split-window -h -c "#{pane_current_path}"
      unbind '"'
      bind - split-window -v -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # C-l is taken by vim-tmux-navigator
      bind C-l send-keys C-l

      unbind r
      bind r source-file $HOME/.config/tmux/tmux.conf \; display "tmux.conf reloaded"

      # Vim-like copy/paste
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane
    '';
  };
}
