# Desktop profile - Full desktop environment with window managers
{ inputs, pkgs, ... }:

let
  fonts = {
    ui = "FiraCode Nerd Font";
    terminal = "FiraCode Nerd Font Med";
  };
in
{
  imports = [
    inputs.stylix.homeModules.stylix
    ../core/default.nix
    ../core/gtk.nix
    ../core/pkgs.nix
    ../dev/tools.nix
    ../dev/claude-code.nix
    ../dev/crush.nix
    ../dev/k9s.nix
    ../dev/opencode.nix
    ../shell/bash.nix
    ../shell/fish.nix
    ../shell/zsh.nix
    ../shell/neovim.nix
    ../shell/helix.nix
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
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    image = ../../.wallpapers/bg2.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  };

  _module.args = { inherit fonts; };
}
