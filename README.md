# NixOS Dotfiles

A modular and well-organized NixOS configuration with home-manager, supporting multiple hosts and window managers.

## Features

- **Flake-based configuration** - Reproducible builds with pinned dependencies
- **Multiple hosts** - Easy management of different machines (personal laptop, work laptop)
- **Home-manager integration** - Declarative user environment configuration
- **Multiple window managers** - Support for both Sway and Niri with shared configuration
- **Secret management** - Agenix for secure handling of sensitive data
- **Declarative disk partitioning** - Disko for automated disk setup
- **Theme system** - Centralized color scheme (Dracula) via nix-colors, propagated to all applications
- **Modular design** - Clean separation between system and home configurations

## Project Structure

```
nixos-dotfiles/
├── flake.nix                 # Main entry point with host configurations
├── flake.lock                # Locked dependencies
├── lib/
│   ├── default.nix           # Helper functions
│   └── mkHost.nix            # Shared host entrypoint
│
├── hosts/                    # Host-specific configurations
│   ├── common/               # Shared host composition
│   │   ├── base.nix
│   │   └── desktop.nix
│   ├── nixos-levinhne/      # Personal laptop
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   ├── disko.nix
│   │   └── cloudflared.nix
│   └── nixos-vinhlq21/      # Work laptop
│       ├── default.nix
│       ├── hardware-configuration.nix
│       ├── disko.nix
│       └── cloudflared.nix
│
├── modules/
│   ├── system/              # Core system settings
│   ├── desktop/             # Desktop-related NixOS modules
│   ├── services/            # Service modules
│   └── dev/                 # Development-oriented system modules
│
├── home/                    # Home-manager user modules
│   ├── default.nix          # Main home-manager entry point
│   ├── profiles/
│   │   └── desktop.nix      # Full desktop profile; sets colorScheme = dracula
│   ├── core/                # Base packages, GTK, xdg
│   ├── dev/                 # git, direnv, claude-code, crush
│   ├── shell/               # fish, bash, zsh, neovim, helix, tmux, zellij
│   ├── terminal/            # kitty, foot
│   └── wm/                  # sway, niri, waybar, mako, kanshi, wpaperd
│
├── config/                  # Raw configuration files
│   ├── nvim/               # Neovim (lazy.nvim)
│   ├── kitty/
│   ├── waybar/
│   └── ...
│
├── packages/
│   └── retrosmart-cursors.nix
│
├── secrets/                 # Encrypted secrets (agenix)
│   ├── secrets.nix
│   └── *.age
│
└── scripts/
    └── backup-ssh-keys.sh
```

## Quick Start

### Prerequisites

- NixOS 25.11 or later
- Flakes enabled in your Nix configuration

### Initial Setup

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url> ~/nixos-dotfiles
   cd ~/nixos-dotfiles
   ```

2. **Generate hardware configuration (for new machine):**
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```

3. **Configure your host:**
   - Edit `flake.nix` to add your host:
     ```nix
     nixosConfigurations.your-hostname = mkHost {
       hostname = "your-hostname";
       username = "your-username";
     };
     ```
   - Create host directory: `hosts/your-hostname/`
   - Copy and modify configuration files from an existing host

4. **Apply the configuration:**
   ```bash
   # For personal laptop
   sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne

   # For work laptop
   sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-vinhlq21

   # Or generic command
   sudo nixos-rebuild switch --flake ~/nixos-dotfiles#your-hostname
   ```

### Updating

```bash
# Update flake inputs
nix flake update

# Rebuild system with updated inputs
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-levinhne
# OR
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-vinhlq21
```

## Configuration Guide

### Adding a New Host

1. Create a new directory in `hosts/`:
   ```bash
   mkdir -p hosts/new-hostname
   ```

2. Create required files:
   - `default.nix` - Host composition
   - `hardware-configuration.nix` - Hardware-specific settings
   - `disko.nix` - Disk partitioning (optional)

3. Add to `flake.nix`:
   ```nix
   nixosConfigurations.new-hostname = mkHost {
     hostname = "new-hostname";
     username = "username";
   };
   ```

### Customizing the Theme

The color scheme is set in `home/profiles/desktop.nix`:

```nix
colorScheme = nix-colors.colorSchemes.dracula;
```

To switch themes, replace `dracula` with any scheme from [nix-colors](https://github.com/misterio77/nix-colors). All applications (kitty, foot, sway, niri, mako, waybar, starship) automatically consume the `colorScheme` attribute via the home-manager module system.

### Switching Window Managers

The configuration supports both Sway and Niri. Both are configured by default. To use only one:

1. Comment out unwanted WM in `home/profiles/desktop.nix`
2. Comment out unwanted system modules in `hosts/common/desktop.nix` if needed

### Managing Secrets

This configuration uses [agenix](https://github.com/ryantm/agenix) for secret management.

1. **Create a secret:**
   ```bash
   # Add your public key to secrets/secrets.nix first
   agenix -e secrets/my-secret.age
   ```

2. **Declare the secret in `modules/system/secrets.nix`:**
   ```nix
   age.secrets.my-secret = {
     file = ../secrets/my-secret.age;
     owner = config.mySystem.userName;
   };
   ```

3. **Export as environment variable** (optional) — add an entry to `secretFiles` in `home/shell/common.nix`:
   ```nix
   secretFiles = [
     { env = "MY_SECRET"; path = "/run/agenix/my-secret"; }
   ];
   ```

   Secrets are decrypted at boot to `/run/agenix/<name>` and exported automatically for all shells (fish, bash, zsh).

### Configuring User

The username is configurable via `mySystem.userName` option in `modules/system/user.nix`. Default is "levinhne".

To use a different username:
```nix
# In flake.nix
nixosConfigurations.my-host = mkHost {
  hostname = "my-host";
  username = "myusername";
};
```

## Common Tasks

### Shell Aliases

All aliases are defined once in `home/shell/common.nix` and shared across fish, bash, and zsh:

```bash
nrs              # Rebuild current host (fish)
update           # Rebuild current host (bash/zsh)
nrs-host <host>  # Rebuild a specific host
clean            # Garbage collect old generations
v                # Open neovim
gs/ga/gc/gp      # Git shortcuts
```

### Cleaning Old Generations

```bash
# Delete old generations
sudo nix-collect-garbage -d

# Or use the alias
clean
```

### Garbage Collection

Automatic garbage collection runs weekly (configured in `modules/system/nix.nix`):
```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
```

## Key Bindings

### Sway / Niri Common Bindings

- `Super + Return` - Terminal (kitty)
- `Super + D` - Application launcher (bemenu)
- `Super + B` - Browser (Google Chrome)
- `Super + Y` - File manager (Nemo)
- `Super + S` - Screenshot area
- `Super + Shift + S` - Screenshot full screen
- `Super + V` - Clipboard history
- `Super + Q` - Close window
- `Super + 1-6` - Switch workspace
- `Super + Shift + 1-6` - Move window to workspace

## Troubleshooting

### Build Fails

1. **Check syntax errors:**
   ```bash
   nix flake check
   ```

2. **Update inputs:**
   ```bash
   nix flake update
   ```

3. **Clean build cache:**
   ```bash
   nix-collect-garbage -d
   ```

### Home-manager Issues

```bash
# Remove existing files that conflict
rm ~/.config/<conflicting-file>

# Force rebuild
home-manager switch --flake ~/nixos-dotfiles#<hostname>
```

### Hardware Config Not Working

If you copied hardware config from another machine:
```bash
# Generate new hardware config
sudo nixos-generate-config --show-hardware-config

# Compare with your hardware-configuration.nix
# Update kernel modules, CPU microcode, etc.
```

## TODO

- [ ] Configure actual git email in `home/dev/git.nix`
- [ ] Move cloudflared credentials to agenix secrets
- [ ] Add actual hardware config for vinhlq21 work laptop
- [ ] Adjust disko.nix device paths for vinhlq21
- [ ] Add tests and CI/CD pipeline
- [ ] Create additional profiles (minimal, server)
- [ ] Document custom packages

## Contributing

This is a personal configuration but feel free to:
- Open issues for bugs or suggestions
- Submit PRs for improvements
- Fork and adapt for your own use

## License

MIT License - Feel free to use and modify as you wish.

## Acknowledgments

- [NixOS](https://nixos.org/) - The purely functional Linux distribution
- [home-manager](https://github.com/nix-community/home-manager) - User environment management
- [agenix](https://github.com/ryantm/agenix) - Secret management
- [disko](https://github.com/nix-community/disko) - Declarative disk partitioning
- [nix-colors](https://github.com/misterio77/nix-colors) - Declarative color schemes
- Dracula theme for the beautiful color scheme
