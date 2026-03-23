# Desktop profile - Full desktop environment with window managers
{ ... }:

let
  theme = import ../core/theme.nix;
  fonts = {
    ui = "FiraCode Nerd Font";
    terminal = "FiraCode Nerd Font Med";
  };
in
{
  _module.args = { inherit theme fonts; };

  imports = [
    ../core/default.nix
    ../core/gtk.nix
    ../core/pkgs.nix
    ../dev/claude-code.nix
    ../dev/crush.nix
    ../shell/bash.nix
    ../shell/fish.nix
    ../shell/neovim.nix
    ../shell/helix.nix
    ../shell/starship.nix
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
  ];
}
