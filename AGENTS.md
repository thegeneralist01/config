# AGENTS.md - AI Assistant Context

This file provides context for AI assistants working with thegeneralist's Nix configuration.

## Quick Commands

### Build & Deploy Commands
```bash
# Build specific host
nixos-rebuild switch --flake .#<hostname>        # Linux
darwin-rebuild switch --flake .#<hostname>       # macOS  

# Update flake dependencies
nix flake update

# Check configuration validity
nix flake check

# Format Nix files  
nixpkgs-fmt **/*.nix

# Clean up old generations
nh clean all --keep 3 --keep-since 4d
```

### Development Commands
```bash
# Enter dev shell with tools
nix develop

# Edit secrets
agenix -e <secret-name>.age

# Re-encrypt all secrets
agenix -r
```

## Architecture Overview

### File Structure Conventions
- **`flake.nix`** - Main entry point, defines inputs/outputs
- **`hosts/`** - Host-specific configurations
  - Each host has `default.nix` that calls `lib.mkSystem`
  - `configuration.nix` contains host-specific settings
- **`modules/`** - Reusable system modules
  - `common/` - Cross-platform modules (always loaded)
  - `darwin/` - macOS-specific modules  
  - `linux/` - Linux-specific modules
- **`lib/`** - Custom library functions
  - `mkSystem` - Main system builder function

### Host Naming & Categorization
- Hosts ending in `mbp` or containing `central-mbp` → Darwin
- All others → NixOS
- Current hosts:
  - `thegeneralist` (NixOS)
  - `thegeneralist-central` (NixOS) 
  - `thegeneralist-mbp` (Darwin)
  - `thegeneralist-central-mbp` (Darwin)

## Code Conventions

### Nix Style Guidelines
- Use `nixpkgs-fmt` for formatting
- Prefer explicit attribute sets over `with` statements
- Use meaningful variable names
- Add comments for complex logic

### Module Organization
```nix
# Standard module structure
{ config, lib, pkgs, ... }:
{
  # Module configuration here
}
```

### Host Configuration Pattern
```nix
# hosts/<hostname>/default.nix
lib: inputs: self: lib.mkSystem "<os>" ./configuration.nix

# hosts/<hostname>/configuration.nix  
{ config, pkgs, ... }: {
  # Host-specific settings
}
```

## Common Modification Patterns

### Adding a New Package
1. **System-wide**: Add to appropriate `modules/*/packages.nix`
2. **User-specific**: Add to home-manager config in host's `configuration.nix`

### Adding a New Module  
1. Create `.nix` file in appropriate `modules/` subdirectory
2. Module is auto-discovered and loaded

### Adding a New Host
1. Create `hosts/<hostname>/` directory
2. Add `default.nix` with system type
3. Add `configuration.nix` with host settings
4. Optionally add `hardware-configuration.nix`

### Managing Secrets
1. Define in `secrets.nix` with proper recipients
2. Reference as `config.age.secrets.<name>.path`
3. Edit with `agenix -e <secret>.age`

## Key Features to Remember

### Distributed Builds
- `thegeneralist-central` is the main build machine
- Other hosts offload builds via SSH
- SSH keys and build users configured automatically

### Binary Caches
- Personal: `cache.thegeneralist01.com`
- Community: `cache.garnix.io`  
- Official: `cache.nixos.org`

### Home Manager Integration
- Configured via `modules/common/home-manager.nix`
- Per-host customization in host's `configuration.nix`
- Includes `nh` tool for optimized rebuilds

### Development Tools
- Development shell includes: `nil`, `nixpkgs-fmt`, `agenix`
- Custom options available via `lib.mkOption`
- Flake inputs follow nixpkgs for consistency

## Debugging Tips

### Build Issues
1. Check syntax: `nix flake check`
2. Update dependencies: `nix flake update`  
3. Clear cache: `nix-collect-garbage -d`
4. Verify module imports and paths

### Secret Issues
1. Check `keys.nix` has correct public keys
2. Verify secret recipient list in `secrets.nix`
3. Re-encrypt if needed: `agenix -r`

### Module Not Loading
1. Verify file is in correct `modules/` subdirectory
2. Check file extension is `.nix`
3. Ensure valid Nix syntax

## Performance Optimizations

### Recommended Practices
- Use distributed builds when available
- Leverage binary caches
- Regular garbage collection via `nh clean`
- Keep flake inputs updated but stable

### Avoiding Rebuilds
- Prefer adding packages to existing modules over creating new ones
- Use overlays for package modifications
- Consider impact on all hosts when modifying common modules

## Testing Strategy

### Before Major Changes
1. Test on single host first
2. Verify flake builds: `nix flake check`
3. Check that all hosts can still build
4. Consider impact on secrets/distributed builds

### Rollback Strategy
```bash
# System level rollback
nixos-rebuild switch --rollback
darwin-rebuild switch --rollback

# Or boot into previous generation from bootloader
```

## User Preferences

### Code Style
- Clean, readable Nix code
- Proper indentation and formatting
- Meaningful comments for complex logic
- Consistent naming conventions

### Organization Preferences  
- Modular approach over monolithic configs
- Platform-specific separation (darwin/linux/common)
- Host-specific customization in host directories
- Secrets properly encrypted and organized

This configuration emphasizes maintainability, security, and cross-platform consistency.
