# NixOS Dotfiles

A modular and well-organized NixOS configuration with home-manager, supporting multiple hosts and window managers.

## Features

- **Flake-based configuration** - Reproducible builds with pinned dependencies
- **Multiple hosts** - Easy management of different machines (personal laptop, work laptop)
- **Home-manager integration** - Declarative user environment configuration
- **Multiple window managers** - Support for both Sway and Niri with shared configuration
- **Secret management** - Agenix for secure handling of sensitive data
- **Declarative disk partitioning** - Disko for automated disk setup
- **Theme system** - Centralized color scheme (Dracula) used across all applications
- **Modular design** - Clean separation between system and home configurations

## Project Structure

```
nixos-dotfiles/
├── flake.nix                 # Main entry point with host configurations
├── flake.lock                # Locked dependencies
│
├── hosts/                    # Host-specific configurations
│   ├── nixos-levinhne/      # Personal laptop
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   ├── disko.nix
│   │   └── cloudflared.nix
│   └── nixos-vinhlq21/      # Work laptop
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       ├── disko.nix
│       └── cloudflared.nix
│
├── system/                   # System-level NixOS modules
│   ├── core.nix             # Nix settings, locale, timezone
│   ├── user.nix             # User management with options
│   ├── boot.nix             # Bootloader configuration
│   ├── fonts.nix            # System fonts
│   ├── graphics.nix         # GPU and graphics drivers
│   ├── audio.nix            # PipeWire audio
│   ├── bluetooth.nix        # Bluetooth support
│   ├── ssh.nix              # SSH daemon
│   ├── sway.nix             # Sway window manager (system)
│   ├── niri.nix             # Niri window manager (system)
│   ├── display-manager.nix  # Ly display manager
│   ├── fcitx5.nix           # Input method (Vietnamese)
│   ├── packages.nix         # System-wide packages
│   ├── secrets.nix          # Agenix secrets configuration
│   └── office.nix           # Office-specific settings (proxy, certs)
│
├── home/                    # Home-manager user modules
│   ├── profiles/
│   │   └── desktop.nix      # Full desktop profile
│   ├── core.nix             # Basic home configuration
│   ├── theme.nix            # Dracula color scheme
│   ├── pkgs.nix             # User packages
│   ├── gtk.nix              # GTK theming
│   ├── kitty.nix            # Kitty terminal
│   ├── foot.nix             # Foot terminal
│   ├── crush.nix            # AI assistant configuration
│   ├── wpaperd.nix          # Wallpaper daemon
│   ├── shell/
│   │   ├── common.nix       # Shared shell configuration
│   │   ├── bash.nix
│   │   ├── fish.nix
│   │   ├── git.nix
│   │   └── starship.nix
│   └── wm/
│       ├── common.nix       # Shared WM configuration
│       ├── sway.nix         # Sway configuration
│       ├── niri.nix         # Niri configuration
│       ├── waybar.nix       # Status bar
│       ├── mako.nix         # Notifications
│       └── kanshi.nix       # Display profiles
│
├── lib/
│   └── default.nix          # Helper functions
│
├── config/                  # Raw configuration files
│   ├── nvim/               # Neovim (lazy.nvim)
│   ├── fish/
│   ├── kitty/
│   ├── sway/
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
     nixosConfigurations = {
       your-hostname = mkHost "your-hostname" "your-username";
     };
     ```
   - Create host directory: `hosts/your-hostname/`
   - Copy and modify configuration files from an existing host

4. **Apply the configuration:**
   ```bash
   sudo nixos-rebuild switch --flake ~/nixos-dotfiles#your-hostname
   ```

### Updating

```bash
# Update flake inputs
nix flake update

# Rebuild system with updated inputs
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<hostname>
```

## Configuration Guide

### Adding a New Host

1. Create a new directory in `hosts/`:
   ```bash
   mkdir -p hosts/new-hostname
   ```

2. Create required files:
   - `configuration.nix` - System configuration
   - `hardware-configuration.nix` - Hardware-specific settings
   - `disko.nix` - Disk partitioning (optional)

3. Add to `flake.nix`:
   ```nix
   nixosConfigurations.new-hostname = mkHost "new-hostname" "username";
   ```

### Customizing the Theme

Edit `home/theme.nix` to change colors. The theme is based on Dracula but can be customized:

```nix
{
  colors = {
    base00 = "#282a36";  # Background
    base05 = "#f8f8f2";  # Foreground
    # ... more colors
  };
}
```

All applications (kitty, foot, sway, niri, mako, starship) will automatically use the new theme.

### Switching Window Managers

The configuration supports both Sway and Niri. Both are configured by default. To use only one:

1. Comment out unwanted WM in `home/profiles/desktop.nix`
2. Comment out unwanted WM in `hosts/<hostname>/configuration.nix`

### Managing Secrets

This configuration uses [agenix](https://github.com/ryantm/agenix) for secret management.

1. **Create a secret:**
   ```bash
   # Add your public key to secrets/secrets.nix first
   agenix -e secrets/my-secret.age
   ```

2. **Declare the secret in `system/secrets.nix`:**
   ```nix
   age.secrets.my-secret = {
     file = ../secrets/my-secret.age;
     owner = config.mySystem.userName;
   };
   ```

3. **Use the secret:**
   ```nix
   # The decrypted secret is available at:
   config.age.secrets.my-secret.path
   ```

### Configuring User

The username is configurable via `mySystem.userName` option in `system/user.nix`. Default is "levinhne".

To use a different username:
```nix
# In flake.nix
nixosConfigurations.my-host = mkHost "my-host" "myusername";

# Or in configuration.nix
mySystem.userName = "myusername";
mySystem.userDescription = "My Full Name";
```

## Common Tasks

### Shell Aliases

**Fish:**
```bash
nrs              # Rebuild system
v                # Open neovim
```

**Bash:**
```bash
update           # Rebuild system
clean            # Garbage collect old generations
gs/ga/gc/gp      # Git shortcuts
```

### Cleaning Old Generations

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete old generations (keep last 3)
sudo nix-collect-garbage -d

# Or use the alias
clean
```

### Garbage Collection

Automatic garbage collection runs weekly (configured in `system/core.nix`):
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

- [ ] Configure actual git email in `home/shell/git.nix`
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
- Dracula theme for the beautiful color scheme
