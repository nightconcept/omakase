# OMAKASE IMPLEMENTATION TASKS

## Overview
Omakase brings the **full Omarchy developer experience** to any Debian-based system through a hybrid approach: Debian base layer for system integration + Nix unstable for bleeding-edge developer tools and declarative configs.

**Core Philosophy:** Amazing developer UX that general users can adopt. Opinionated defaults. Latest everything. Zero compromises.

## Installation Workflow
```
Developer runs: curl -sSf https://raw.githubusercontent.com/.../boot.sh | bash
  ↓
boot.sh: Detect Debian-based OS → clone repo → call install.sh
  ↓  
install.sh: Debian base layer + Nix unstable + Hyprland flake setup
  ↓
home-manager switch --flake .#danny: Full Omarchy-inspired configuration
  ↓
omakase update: Custom script for easy maintenance
```

## Phase 1: Bootstrap Infrastructure ✅ **COMPLETED**

### Task 1.1: Create Distribution-Agnostic boot.sh ✅ **COMPLETED**
- [x] Detect Debian-based OS (Debian, Ubuntu, Pop!_OS, etc.)
- [x] Auto-detect package manager (apt/apt-get) and adjust accordingly
- [x] Handle distribution-specific package names and repositories
- [x] Update repo references to omakase
- [x] Add error handling for unsupported systems
- [x] Comprehensive logging with color output
- **🧪 DRY RUN CHECKPOINT**: `bash boot.sh --help` (should show help without executing)
- **🧪 VM TEST CHECKPOINT**: Test full boot.sh execution on clean Debian 12 VM

### Task 1.2: Enhance install.sh for Distribution-Agnostic Pure Nix ✅ **COMPLETED**
- [x] **Username flexibility**: Prompt for username with `$USER` as default
- [x] **Minimal base layer**: Install only `curl git` via package manager
- [x] **Distribution detection**: Support Debian, Ubuntu, Fedora, openSUSE, Arch, etc.
- [x] **Pure Nix approach**: All system integration via user services + Nix packages
- [x] Add error handling and logging with fallback strategies
- [x] Add Nix channel setup for unstable (for newer packages)
- [x] Configure Nix settings for optimal performance  
- [x] Add nixGL setup verification
- [x] Add Home Manager flake mode setup for any username
- [x] Apply configuration: `home-manager switch --flake ".#$USERNAME"`
- [x] Create omakase update script
- **🧪 DRY RUN CHECKPOINT**: `bash install.sh --dry-run` (if implemented)
- **🧪 VM TEST CHECKPOINT**: Test full install.sh on clean Debian 12 VM

### Task 1.3: Create Folder Structure ✅ **COMPLETED**
- [x] Create applications/ directory structure:
  ```
  applications/
  ├── nixvim/          # Neovim with own flake
  ├── wezterm/         # Terminal 
  ├── waybar/          # Status bar
  ├── zsh/             # Shell with p10k
  ├── hyprland/        # Window manager
  ├── mako/            # Notifications
  └── walker/          # Launcher
  ```
- [x] Create root-level modules/ directory structure:
  ```
  modules/
  ├── desktop.nix         # Desktop environment setup
  ├── development.nix     # Dev tools  
  ├── hardware.nix        # Hardware support (brightness, bluetooth, etc.)
  ├── audio.nix          # PipeWire user services
  ├── themes.nix         # Theme management (Tokyo Night default)
  └── default.nix        # Import all modules + applications
  ```
- [x] Create home/ directory structure:
  ```
  home/
  └── home.nix           # Main home config (imports ../modules)
  ```
- [x] Create bin/ directory for utility scripts (omakase-*)
- [x] Create config/ directory for system configs (environment.d, systemd)
- **🧪 DRY RUN CHECKPOINT**: `find . -name "*.nix" -type f | head -10` (verify structure exists)
- **🧪 SYNTAX CHECK**: `nix-instantiate --parse modules/default.nix` (verify Nix syntax)

### Task 1.4: Create Developer-Optimized flake.nix Structure ✅ **COMPLETED**
- [x] Define main flake.nix with cutting-edge inputs:
  - **nixpkgs-unstable** (bleeding-edge everything)
  - **home-manager** (latest features)
  - **nixvim** (modern Neovim experience)
  - **hyprland flake** (absolute latest compositor)
  - **devenv** (modern development environments)
  - **nixpkgs-wayland**, **nixgl**, **catppuccin** (additional modern inputs)
- [x] Set up homeConfigurations for "danny" user (expandable to multiple profiles)
- [x] Configure integration flow: flake.nix → home/home.nix → ../modules/default.nix → ../applications/*/default.nix
- [x] Support any username via homeConfigurations."$USERNAME"
- [x] Add flake-utils for potential multi-platform future
- [x] Optimize for fast builds and caching with overlays and cross-platform support
- [x] Add development shells, packages, and CI checks
- **🧪 DRY RUN CHECKPOINT**: `nix flake check --no-build` (validate flake structure)
- **🧪 BUILD TEST**: `nix build .#homeConfigurations.danny.activationPackage --dry-run`
- **🧪 VM TEST CHECKPOINT**: Full Home Manager switch test on clean VM

---

## **🧪 PHASE 1 TESTING CHECKLIST**

Before proceeding to Phase 2, verify Phase 1 works completely:

### **Dry Run Tests (Safe - No System Changes)**
1. **Structure Verification**:
   ```bash
   find . -name "*.nix" -type f | wc -l  # Should show multiple .nix files
   ls applications/*/default.nix         # Should show 7 application modules
   ls modules/*.nix                      # Should show 6 module files
   ```

2. **Syntax Validation**:
   ```bash
   nix flake check --no-build            # Validate flake structure
   nix-instantiate --parse flake.nix     # Check main flake syntax
   nix-instantiate --parse modules/default.nix  # Check module imports
   ```

3. **Build Validation (No Apply)**:
   ```bash
   nix build .#homeConfigurations.danny.activationPackage --dry-run
   home-manager build --flake .#danny --dry-run
   ```

### **🖥️ VM Testing Requirements**
**CRITICAL**: Test on fresh Debian 12 VM before using on main system:

1. **Bootstrap Test**:
   ```bash
   curl -sSf https://raw.githubusercontent.com/your-repo/omakase/main/boot.sh | bash
   ```

2. **Manual Test**:
   ```bash
   git clone https://github.com/your-repo/omakase.git
   cd omakase
   bash install.sh
   ```

3. **Verification**:
   - All packages install without errors
   - Home Manager configuration applies successfully  
   - Tokyo Night theme is active
   - omakase update command works

---

## Phase 2: Package Installation Strategy

### Task 2.1: Pure Nix Package Strategy  
**Minimal Base Layer (distribution package manager):**
```bash
# Bootstrap essentials only - distribution agnostic
sudo apt install -y curl git      # Debian/Ubuntu
sudo dnf install -y curl git      # Fedora  
sudo zypper install -y curl git   # openSUSE
sudo pacman -S curl git           # Arch
```

**Everything Else via Nix (modules/*):**
- [ ] **System Integration** (`modules/desktop.nix`): Desktop portals, polkit via user services
- [ ] **Audio System** (`modules/audio.nix`): PipeWire + WirePlumber as user services  
- [ ] **Hardware Support** (`modules/hardware.nix`): Brightness, bluetooth, power management
- [ ] **Applications**: All GUI and CLI apps via `applications/*/default.nix`
- [ ] **Fonts**: All fonts via Home Manager font configuration
- [ ] **Development**: All dev tools, languages, containers via Nix

### Task 2.2: Nix/Home Manager Packages
Configure in `home.nix` and modules:

**Desktop Environment (Nix):**
- hyprland + hypr* ecosystem
- waybar, mako, swaybg
- wl-clipboard, wl-clip-persist

**Modern CLI Tools (Nix):**
- wezterm, bat, eza, ripgrep, fd, fzf, zoxide
- btop, fastfetch, lazygit
- glow, devenv, direnv

**Development (Nix):**
- nixvim with full configuration
- fira-code-nerdfont, jetbrains-mono-nerdfont
- uv (Python package manager)

**User Applications (Nix):**
- Any GUI apps that benefit from latest versions
- Applications needing specific configurations

### Task 2.3: Create Package Installation Matrix

| Package | Debian | Nix | Reason |
|---------|--------|-----|--------|
| firefox | ✓ | | System integration, ESR stability |
| hyprland | | ✓ | Latest features, frequent updates |
| nautilus | ✓ | | GNOME integration |
| wezterm | | ✓ | Latest features, config flexibility |
| git | ✓ | | System tool, security updates |
| lazygit | | ✓ | User tool, latest features |
| fonts-inter | ✓ | | System-wide font installation |
| fira-code-nerdfont | | ✓ | Nerd Font variants |

## Phase 3: Configuration Architecture

### Task 3.1: Create Application Module Pattern
Each application in `applications/` follows this structure:
```
applications/wezterm/
├── default.nix          # Home Manager module (programs.wezterm config)
├── wezterm.lua          # Application config files
└── themes/              # App-specific theme files (optional)

applications/waybar/
├── default.nix          # Home Manager module (programs.waybar config)  
├── config.jsonc         # Waybar configuration
├── style.css            # Waybar styles
└── modules/             # Custom waybar modules (optional)

applications/nixvim/
├── default.nix          # nixvim configuration
├── config/              # Vim configuration files  
├── plugins/             # Plugin configurations
└── keymaps/             # Key mappings
```

### Task 3.2: Create Root-Level Module Structure
```
modules/
├── desktop.nix      # Desktop environment setup (Hyprland, portals, etc.)
├── development.nix  # Dev tools and environment (devenv, direnv, git)  
├── hardware.nix     # Hardware support (brightness, bluetooth, power management)
├── audio.nix        # PipeWire + WirePlumber user services
├── themes.nix       # Theme management and switching
└── default.nix      # Imports all applications: ../applications/*/default.nix

home/
└── home.nix         # Main home config (imports ../modules)
```

### Task 3.3: Extract Configurations from Source Systems
- [ ] **From omarchy/lomarchy**: Extract Hyprland configs, keybindings, themes, waybar configs
- [ ] **From nix-home**: Reference working Nix module patterns
- [ ] **From dotfiles-nix**: Use flake architecture patterns

### Task 3.4: Configuration Conversion Strategy
- [ ] Convert shell-based configs to Nix expressions
- [ ] Create modular, toggleable features  
- [ ] Ensure all configs are declarative and version-controlled
- [ ] Add configuration validation where possible

## Phase 4: Core System Implementation

### Task 4.1: Hyprland Desktop Environment
- [ ] Configure Hyprland with Omarchy-inspired aesthetics
- [ ] Set up hyprshot, hyprpicker, hyprlock, hypridle
- [ ] Configure proper Wayland/XDG portal integration
- [ ] Test with common applications

### Task 4.2: Developer-First Terminal and Shell Setup  
- [ ] Configure WezTerm with Omarchy aesthetics + developer optimizations
- [ ] Set up Zsh + Oh My Zsh + Starship for maximum productivity
- [ ] Configure developer-focused OMZ plugins (git, docker, kubectl, etc.)
- [ ] Integrate modern CLI tools (bat, eza, ripgrep, fd, fzf, zoxide)
- [ ] Create Omarchy-inspired aliases and developer shortcuts
- [ ] Set up smart completions and fuzzy history search

### Task 4.3: IDE-Grade Development Environment
- [ ] Configure Nixvim as full IDE replacement (LSPs, completions, debugging)
- [ ] Set up integrated development workflow (git, lazygit, devenv, direnv)  
- [ ] Configure comprehensive language support (Python, JS/TS, Go, Rust, Nix)
- [ ] Add developer quality-of-life features (project templates, snippets, etc.)
- [ ] Integrate container development workflow (podman, lazydocker)
- [ ] Test full development workflow for multiple languages

### Task 4.4: Application Integration
- [ ] Configure Firefox with basic settings
- [ ] Set up file manager and system utilities
- [ ] Configure media applications (mpv, imv)
- [ ] Test GUI application integration

## Phase 5: System Services and Hardware

### Task 5.1: Audio System
- [ ] Configure PipeWire/WirePlumber properly
- [ ] Set up audio controls and media keys
- [ ] Test audio device switching
- [ ] Configure system sounds (if any)

### Task 5.2: Power and Hardware Management  
- [ ] Configure power profiles and battery management
- [ ] Set up brightness controls
- [ ] Test hardware key bindings
- [ ] Configure suspend/resume

### Task 5.3: Network and Security
- [ ] Configure NetworkManager integration
- [ ] Set up firewall rules (ufw)
- [ ] Configure GNOME Keyring integration
- [ ] Test WiFi and Bluetooth functionality

## Phase 6: Theming and Polish

### Task 6.1: Visual Consistency
- [ ] Apply Omarchy-inspired color schemes
- [ ] Configure GTK and Qt theming
- [ ] Set up consistent fonts across applications  
- [ ] Configure cursor and icon themes

### Task 6.2: Wallpapers and Aesthetics
- [ ] Add Omarchy/Lomarchy wallpapers
- [ ] Configure dynamic wallpaper system (if desired)
- [ ] Set up screenshot and color picker tools
- [ ] Polish visual transitions and effects

## Phase 7: Testing and Validation

### Task 7.1: Fresh Installation Testing
- [ ] Test on multiple Debian versions (12, testing)
- [ ] Test on different hardware configurations
- [ ] Validate all package installations work
- [ ] Test upgrade and rollback scenarios

### Task 7.2: Functionality Testing
- [ ] Test all keybindings and shortcuts
- [ ] Verify all applications launch properly
- [ ] Test development environment workflows
- [ ] Validate system integration features

### Task 7.3: Performance Optimization
- [ ] Optimize Nix build times
- [ ] Configure appropriate caching
- [ ] Test system resource usage
- [ ] Optimize startup time

## Phase 8: Documentation and Tooling

### Task 8.1: Create Custom Update Script
- [ ] Create `omakase update` command for easy maintenance
- [ ] Handle Nix flake updates, channel updates, and system packages
- [ ] Add rollback capabilities for failed updates
- [ ] Include system health checks and optimization
- [ ] Add update notifications and changelog display

### Task 8.2: User Documentation
- [ ] Create developer-focused README with quick start
- [ ] Document customization patterns (adding languages, tools, etc.)
- [ ] Create troubleshooting guide for common developer scenarios
- [ ] Add performance optimization guide

### Task 8.3: Testing Infrastructure
- [ ] Set up VM-based testing pipeline (manual for now)
- [ ] Create test matrix: Debian 12, Ubuntu 22.04+, Pop!_OS
- [ ] Automated configuration validation scripts
- [ ] Performance benchmarking for developer workflows

## Implementation Priority & Next Steps

### Immediate Priorities (Week 1-2):
1. **Phase 1**: Bootstrap infrastructure (boot.sh, install.sh, basic flake.nix)
2. **Phase 2**: Package installation strategy implementation
3. **Basic Hyprland + WezTerm**: Get minimal desktop working

### Short Term (Week 3-4):
4. **Phase 4**: Complete desktop environment and developer tools
5. **Testing**: VM testing pipeline on target distributions
6. **Phase 8.1**: Custom update script

### Medium Term (Month 2):
7. **Phases 5-6**: System services, theming, polish
8. **Phase 7**: Comprehensive testing and optimization
9. **Documentation**: Developer-focused guides

### Key Success Metrics:
- [ ] **5-minute setup**: From curl command to fully functional developer desktop
- [ ] **Omarchy experience parity**: Visual and functional equivalence to original
- [ ] **Zero manual config**: Everything works out of the box for developers
- [ ] **Distribution agnostic**: Works on any major Debian-based system
- [ ] **Performance**: Fast, responsive, optimized for development workflows
- [ ] **Maintainable**: Easy updates, rollbacks, and customization

### Architecture Decisions Made:
✅ **Nix Strategy**: nixpkgs-unstable for everything (latest packages)  
✅ **Hyprland**: Official flake input (bleeding-edge compositor)  
✅ **Shell**: Oh My Zsh + Starship (developer productivity)  
✅ **Target**: Fresh installs, Debian-based OS support  
✅ **Philosophy**: Developer UX first, opinionated defaults  
✅ **Updates**: Custom `omakase update` script  
✅ **No backups**: Fresh install assumption

## Success Metrics
- [ ] Single-command installation works on fresh Debian 12
- [ ] All essential applications launch and work properly
- [ ] System feels responsive and polished
- [ ] Configuration is fully declarative and reproducible
- [ ] Easy to customize and extend
- [ ] Stable and reliable for daily use

---

*This document should be updated as implementation progresses and requirements are clarified.*