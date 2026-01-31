# AGENTS.md - AI Assistant Context

This file provides minimal context for assistants working with this Nix config repo.

## Architecture Overview

### File Structure Conventions
- `flake.nix` - Main entry point, defines inputs/outputs
- `hosts/` - Host-specific configurations
  - Each host has `default.nix` that calls `lib.mkSystem`
  - `configuration.nix` contains host-specific settings
- `modules/` - Reusable system modules
  - `common/` - Cross-platform modules (always loaded)
  - `darwin/` - macOS-specific modules
  - `linux/` - Linux-specific modules
- `lib/` - Custom library functions
  - `mkSystem` - Main system builder function

### Host Naming & Categorization
- Hosts ending in `mbp` or containing `central-mbp` -> Darwin
- All others -> NixOS
- Current hosts:
  - `thegeneralist` (NixOS)
  - `thegeneralist-central` (NixOS)
  - `thegeneralist-mbp` (Darwin)
  - `thegeneralist-central-mbp` (Darwin)
