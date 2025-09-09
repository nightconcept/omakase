# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Omakase is an opinionated Debian configuration system inspired by DHH's Omarchy that uses Nix and Home Manager for package and configuration management. It combines shell scripts and Nix flakes to provide Omarchy-like opinions for Debian installations while maintaining system stability.

The project integrates configurations from multiple sources:
- **omarchy**: Original Hyprland-based Arch configuration 
- **lomarchy**: Less opinionated, more FOSS-centric fork of Omarchy
- **dotfiles-nix**: Nix flake configurations for cross-platform dotfiles
- **nix-home**: Reference implementation of Hyprland on Debian via Nix (existing working setup for reference)

## Architecture

### Main Components

- `flake.nix`: Main Nix flake defining Home Manager configuration for user "danny"
- `install.sh`: Bootstrap script that installs Nix, Home Manager, and nixGL on Debian
- `omarchy/`, `lomarchy/`: Source configurations for visual/aesthetic inspiration and specific settings
- `dotfiles-nix/`: Complete Nix-based dotfiles system for reference
- `nix-home/`: Reference implementation of existing Hyprland-on-Debian setup

### Configuration Flow

1. **Bootstrap**: `install.sh` installs Nix ecosystem on Debian
2. **Flake Configuration**: `flake.nix` defines Home Manager setup with:
   - nixvim for Neovim configuration
   - Custom modules from `./nix_modules`
   - Nixvim configuration from `./nixvim`
3. **Integration Sources**: Pull configurations from omarchy/lomarchy for aesthetics and dotfiles-nix for structure
4. **Reference**: `nix-home/` provides working Hyprland-on-Debian examples to reference

## Common Commands

### Initial Setup
```bash
# Run the bootstrap installation
./install.sh
```

### Home Manager Operations
```bash
# Apply Home Manager configuration
home-manager switch --flake .#danny

# Update flake inputs
nix flake update

# Check flake configuration
nix flake check

# Show available configurations
nix flake show
```

### Development Commands
```bash
# Test configuration changes without applying
home-manager build --flake .#danny

# Check what packages will be installed
nix-env -qa --available
```

## Key Configuration Areas

### Package Management
- Core packages defined in `nix-home/home.nix`
- Includes development tools (devenv, mise), CLI utilities (bat, eza, ripgrep), and Hyprland components

### Configuration Sources
- **omarchy/lomarchy**: Contains shell scripts, themes, and application configurations for visual inspiration
- **dotfiles-nix**: Provides structured Nix flake patterns and Home Manager module organization  
- **nix-home**: Reference implementation showing working Hyprland + Debian setup via Nix (available modules: btop, hyprland, neovim, rofi, waybar, wezterm, zsh)

### Target System
- **OS**: Debian (for stability)
- **Display**: Hyprland (Wayland compositor)
- **Terminal**: WezTerm
- **Shell**: Zsh with Powerlevel10k
- **Editor**: Neovim via nixvim
- **Package Manager**: Nix with Home Manager

## Development Workflow

1. Extract desired configurations from omarchy/lomarchy directories for aesthetics and specific app settings
2. Reference dotfiles-nix structure for proper Nix flake organization patterns
3. Use nix-home as working example of Hyprland on Debian via Nix
4. Modify main `flake.nix` and associated modules to integrate the desired features
5. Test changes with `home-manager build --flake .#danny`
6. Apply changes with `home-manager switch --flake .#danny`
7. Update flake inputs periodically with `nix flake update`