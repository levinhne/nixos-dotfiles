# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Rebuild Commands

```bash
# Rebuild and switch current host (fish alias)
nrs

# Rebuild specific host
nrs-host nixos-levinhne
nrs-host nixos-vinhlq21

# Rebuild manually
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne

# Check flake for syntax errors (before applying)
nix flake check

# Update flake inputs
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d   # or: clean
```

## Architecture Overview

### Entry Point & Host Construction

`flake.nix` → `lib/mkHost.nix` is the composition pipeline. `mkHost` takes `{ hostname, username }` and wires together:
1. **Disko** (disk partitioning) from `hosts/<hostname>/disko.nix`
2. **NixOS modules** from `hosts/<hostname>/default.nix`
3. **Home-manager** pointed at `home/default.nix`, which imports `home/profiles/desktop.nix`

Two special package sets flow through `specialArgs`/`extraSpecialArgs`:
- `pkgs` — stable nixpkgs (nixos-25.11)
- `pkgs-unstable` — nixos-unstable, for packages that need newer versions

### Host Configuration Layer

```
hosts/
  common/
    base.nix      # system modules: boot, nix, networking, user, secrets, ssh, docker
    desktop.nix   # desktop modules: audio, bluetooth, display-manager, fonts, niri, sway, fcitx5
  nixos-levinhne/ # personal laptop
  nixos-vinhlq21/ # work laptop
```

Each host `default.nix` imports `common/base.nix` + `common/desktop.nix` + host-specific overrides.

### Home-manager Layer

```
home/
  profiles/desktop.nix   # master import list for all home modules; sets colorScheme = dracula
  core/                  # base packages, GTK, xdg
  shell/                 # fish, bash, zsh, neovim, helix, tmux
  terminal/              # kitty, foot
  wm/                    # sway, niri, waybar, mako, kanshi, wpaperd
  dev/                   # git, direnv, claude-code, crush
```

`home/shell/common.nix` is the single source of truth for shell aliases and rebuild functions — fish, bash, and zsh all import from it.

### Theme System

`home/profiles/desktop.nix` sets `colorScheme = nix-colors.colorSchemes.dracula`. This `colorScheme` attribute is passed through home-manager's module system and consumed by WM/terminal configs via `{ colorScheme, ... }` args. All colors flow from this single declaration.

Fonts are defined as a local `fonts` attrset in `desktop.nix` and passed via `_module.args`.

### Secret Management (Agenix)

Secrets are encrypted `.age` files in `secrets/`. Declared in `modules/system/secrets.nix` and decrypted at boot to `/run/agenix/<name>`.

Shell init (`home/shell/common.nix`) reads from `/run/agenix/` and exports as env vars (e.g. `ANTHROPIC_AUTH_TOKEN`, `FPT_API_KEY`).

To add a new secret:
1. Add public keys to `secrets/secrets.nix`, then `agenix -e secrets/my-secret.age`
2. Declare in `modules/system/secrets.nix`
3. Export in `home/shell/common.nix` → `secretFiles` list if it needs to be an env var

### Raw Config Files

`config/` contains raw config files (nvim, kitty, sway, waybar, etc.) managed via `home.file` or `xdg.configFile` in the corresponding home-manager modules. Neovim uses lazy.nvim.
