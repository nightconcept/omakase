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

### Phase 1: Bootstrap Infrastructure ✅ **COMPLETED**
1. **Distribution-agnostic boot.sh**: Detects Debian-based systems, handles package managers, comprehensive error handling
2. **Enhanced install.sh**: Multi-distro support, pure Nix approach, creates omakase update script  
3. **Complete folder structure**: applications/, modules/, home/, bin/, config/ with all placeholder files
4. **Developer-optimized flake.nix**: Cutting-edge inputs (nixpkgs-unstable, Hyprland, nixvim, etc.)

### Validation Commands (Dry Run Testing)
```bash
# Structure verification
find . -name "*.nix" -type f | wc -l          # Should show ~10+ Nix files
ls applications/*/default.nix                 # Should show 7 application modules

# Syntax validation  
nix-instantiate --parse flake.nix            # Check main flake syntax
nix-instantiate --parse modules/default.nix   # Check module imports

# Flake validation
nix flake check --no-build                   # Validate flake structure
nix build .#homeConfigurations.danny.activationPackage --dry-run  # Test build
```

### Configuration Approach
1. **Audio**: Configured via `xdg.configFile` for PipeWire/WirePlumber (user-level configs in ~/.config/)
2. **Themes**: Tokyo Night as default with comprehensive GTK/Qt integration
3. **Applications**: Modular structure with placeholder configs ready for expansion
4. **System Integration**: User services + Nix packages approach (no system-level service dependencies)

### Current Status
- ✅ All validation commands pass 
- ✅ Tokyo Night theme integrated
- ✅ PipeWire configured via config files (not services)
- ✅ Hyprland basic configuration added
- 🔄 Ready for Phase 2: Package Installation Strategy

### Next Development Steps
1. Extract configurations from omarchy/lomarchy directories for specific applications
2. Reference dotfiles-nix structure for advanced Nix patterns
3. Use nix-home as working examples for specific integrations
4. Test changes: `nix build .#homeConfigurations.danny.activationPackage --dry-run`
5. Apply changes: `home-manager switch --flake .#danny`
6. Update inputs: `nix flake update`

## Application Integration Development Pattern

When adding a new application to Omakase, follow this systematic process:

### Standard Process for Each Application

#### Phase A: Analysis & Planning
1. **Configuration Source Priority** (in order):
   - **omarchy**: Primary source for configs, themes, keybindings
   - **nix-home**: Reference for Nix module patterns and Home Manager integration
   - **lomarchy**: Different applications NOT in omarchy that we decided to use
   - **dotfiles-nix**: Final fallback reference for Nix flake patterns

2. **Configuration Inventory**:
   - List all config files and their locations
   - Identify theme-sensitive settings (colors, fonts, etc.)
   - Document dependencies and systemd services
   - Check theme compatibility

#### Phase B: Implementation
1. **Create Application Structure**:
   ```
   applications/[app]/
   ├── default.nix          # Home Manager module
   ├── [app-config-files]   # Main config files  
   ├── themes/              # Theme-specific variants (if applicable)
   │   ├── catppuccin/
   │   ├── tokyo-night/
   │   └── gruvbox/
   └── scripts/             # App-specific scripts (if needed)
   ```

2. **Extract & Convert**: Copy from source systems, convert to Nix expressions, create theme variants

3. **Create Home Manager Module**: Define `programs.[app]` config with `builtins.readFile` references

#### Phase C: Integration & Testing  
1. Add import to `modules/default.nix`
2. Test Home Manager build/switch 
3. Verify app functionality and theme switching
4. Add helper scripts to `bin/` if needed

### Application Priority Order
**Tier 1**: hyprland, waybar, mako, wezterm, zsh
**Tier 2**: nixvim, walker, firefox, nautilus
**Tier 3**: git, direnv, lazygit, btop
**Tier 4**: mpv, obsidian, spotify