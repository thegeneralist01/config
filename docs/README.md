# thegeneralist's Nix Configuration

A comprehensive Nix flake configuration supporting both NixOS (Linux) and nix-darwin (macOS) systems with home-manager integration.

## Overview

This configuration provides a unified way to manage multiple machines across different platforms:
- **NixOS hosts**: `thegeneralist`, `thegeneralist-central` 
- **Darwin hosts**: `thegeneralist-mbp`, `thegeneralist-central-mbp`

## Quick Start

### Prerequisites
- Nix package manager with flakes enabled
- Git for cloning the repository

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/thegeneralist01/config.git ~/config
   cd ~/config
   ```

2. For NixOS systems:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

3. For Darwin systems:
   ```bash
   darwin-rebuild switch --flake .#<hostname>
   ```

### Development Environment

Enter the development shell for configuration management:
```bash
nix develop
```

This provides:
- `nil` - Nix language server
- `nixpkgs-fmt` - Nix formatter  
- `agenix` - Secret management

## Architecture

### Directory Structure

```
├── docs/           # Documentation
├── flake.nix       # Main flake configuration
├── flake.lock      # Locked dependency versions
├── hosts/          # Host-specific configurations
│   ├── default.nix # Host discovery and categorization
│   └── <hostname>/ # Individual host configurations
├── lib/            # Custom library functions
│   ├── default.nix # Library entry point
│   ├── option.nix  # Option utilities
│   └── system.nix  # System building functions
├── modules/        # Reusable system modules
│   ├── common/     # Cross-platform modules
│   ├── darwin/     # macOS-specific modules
│   └── linux/      # Linux-specific modules
├── keys.nix        # Age public keys for secrets
└── secrets.nix     # Encrypted secrets
```

### Key Components

#### Flake Inputs
- **nixpkgs**: Main package repository (nixos-unstable)
- **home-manager**: Dotfiles and user environment management
- **nix-darwin**: macOS system configuration
- **agenix**: Age-based secret management
- **ghostty**: Modern terminal emulator
- **fenix**: Rust toolchain provider

#### Library Functions
- `mkSystem`: Core system builder for both Linux and Darwin
- `mkOption`: Custom option utilities
- Host auto-discovery and categorization

## Host Configuration

### Adding a New Host

1. Create a new directory under `hosts/`:
   ```bash
   mkdir hosts/new-hostname
   ```

2. Create the host's `default.nix`:
   ```nix
   lib: inputs: self: lib.mkSystem "linux" ./configuration.nix
   # or for macOS:
   lib: inputs: self: lib.mkSystem "darwin" ./configuration.nix
   ```

3. Create `configuration.nix` with your host-specific settings:
   ```nix
   { config, pkgs, ... }: {
     # Host-specific configuration here
   }
   ```

4. Rebuild your flake:
   ```bash
   nix flake lock  # Update lock file if needed
   nixos-rebuild switch --flake .#new-hostname
   ```

### Host Categorization

Hosts are automatically categorized based on naming conventions:
- Names ending with `mbp` or containing `central-mbp` → Darwin
- All others → NixOS

## Module System

### Common Modules
Located in `modules/common/`, these are loaded on all systems:
- `nix.nix` - Nix configuration, caches, and distributed builds
- `home-manager.nix` - User environment management
- `packages.nix` - Common packages
- `git.nix`, `neovim.nix`, `zsh.nix` - Development tools
- `agenix.nix` - Secret management

### Platform-Specific Modules
- `modules/darwin/` - macOS-specific (SSH, Karabiner, packages)  
- `modules/linux/` - Linux-specific (boot, networking, X11, NVIDIA)

### Creating Custom Modules

1. Add your module to the appropriate directory:
   ```nix
   # modules/common/mymodule.nix
   { config, pkgs, ... }: {
     # Module configuration
   }
   ```

2. The module is automatically discovered and loaded

## Secret Management

Uses `agenix` for encrypted secrets management:

1. Add recipient public keys to [`keys.nix`](file:///Users/thegeneralist/misc/config-copy/keys.nix)
2. Define secrets in [`secrets.nix`](file:///Users/thegeneralist/misc/config-copy/secrets.nix)  
3. Edit secrets: `agenix -e secret-name.age`
4. Reference in configuration: `config.age.secrets.secret-name.path`

## Distributed Builds

The configuration includes distributed build support:
- `thegeneralist-central` serves as the build machine
- Other hosts can offload builds via SSH
- Shared binary caches for faster builds

## Binary Caches

Configured caches for improved build performance:
- `cache.thegeneralist01.com` - Personal cache
- `cache.garnix.io` - Community cache
- `cache.nixos.org` - Official cache

## Development Workflow

### Updating Dependencies
```bash
nix flake update
```

### Formatting Code
```bash
nixpkgs-fmt **/*.nix
```

### Checking Configuration
```bash
nix flake check
```

### Cleaning Up
```bash
# Via nh (configured in home-manager)
nh clean all --keep 3 --keep-since 4d

# Manual cleanup
nix-collect-garbage -d
```

## Common Tasks

### Installing Packages System-wide
Add to the appropriate `modules/*/packages.nix` file.

### Installing User Packages
Modify the home-manager configuration in your host's `configuration.nix`.

### Updating a Single Host
```bash
nixos-rebuild switch --flake .#hostname
# or
darwin-rebuild switch --flake .#hostname  
```

### Rolling Back Changes
```bash
nixos-rebuild switch --rollback
# or
darwin-rebuild switch --rollback
```

## Troubleshooting

### Build Failures
1. Check flake lock compatibility: `nix flake update`
2. Clear build cache: `nix-collect-garbage -d`
3. Verify module syntax: `nix flake check`

### Secret Access Issues
1. Verify keys are properly configured in `keys.nix`
2. Re-encrypt secrets: `agenix -r`
3. Check file permissions on age keys

### Performance Issues  
1. Enable distributed builds to `thegeneralist-central`
2. Verify binary cache access
3. Use `nh` for optimized rebuilds

## Contributing

1. Follow existing code style and organization
2. Test changes on a single host before applying broadly
3. Update documentation for significant changes
4. Use meaningful commit messages

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix-Darwin](https://github.com/nix-darwin/nix-darwin)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Agenix](https://github.com/ryantm/agenix)
