# Desktop profile - Full desktop environment with window managers
{ nix-colors, ... }:

let
  fonts = {
    ui = "FiraCode Nerd Font";
    terminal = "FiraCode Nerd Font Med";
  };
in
{
  imports = [
    nix-colors.homeManagerModules.default
    ../core/default.nix
    ../core/gtk.nix
    ../core/pkgs.nix
    ../dev/aider.nix
    ../dev/claude-code.nix
    ../dev/crush.nix
    ../dev/gitnexus.nix
    ../dev/k9s.nix
    ../dev/opencode.nix
    # ../dev/zeroclaw.nix
    ../shell/bash.nix
    ../shell/fish.nix
    ../shell/zsh.nix
    ../shell/neovim.nix
    ../shell/helix.nix
    # ../shell/starship.nix
    ../shell/tmux.nix
    ../terminal/foot.nix
    ../terminal/kitty.nix
    ../wm/kanshi.nix
    ../wm/sway.nix
    ../wm/niri.nix
    ../wm/waybar.nix
    ../wm/mako.nix
    ../wm/wpaperd.nix
    ../dev/git.nix
    ../dev/direnv.nix
    ../dev/webdiff.nix
  ];

  colorScheme = nix-colors.colorSchemes.dracula;

  _module.args = { inherit fonts; };
}
