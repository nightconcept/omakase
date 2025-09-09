# Omakase Product Requirements Document (PRD)

## Project Overview

**Omakase** is an opinionated Debian configuration system that brings the aesthetic and functional appeal of Omarchy to stable Debian systems using Nix and Home Manager for reliable package and configuration management.

## Goals

1. **Stability First**: Use Debian as the base OS for rock-solid system reliability
2. **Aesthetic Excellence**: Replicate the visual appeal and modern feel of Omarchy/Lomarchy
3. **Declarative Management**: Leverage Nix/Home Manager for reproducible, version-controlled configurations
4. **Easy Deployment**: Single-command installation and updates
5. **Curated Experience**: Provide an opinionated but excellent default setup
6. **Reusable Foundation**: Create a flake that can be imported by other configurations (like dotfiles-nix) as a base layer

## Architecture

### Installation Flow
```
User: curl -sSf https://raw.githubusercontent.com/.../boot.sh | bash
  ↓
boot.sh: Clone repo → call install.sh (Debian-compatible)
  ↓
install.sh: Debian base packages + Nix environment setup
  ↓
home-manager switch --flake .#danny: Apply full configuration
```

### Folder Structure

```
omakase/
├── flake.nix                    # Main flake with Home Manager config
├── install.sh                  # Bootstrap script (Nix + Home Manager + nixGL)
├── boot.sh                     # Quick setup script
│
├── applications/               # Application-specific configs
│   ├── nixvim/                # Neovim via nixvim (gets own folder despite flake)
│   │   ├── config/
│   │   ├── plugins/
│   │   └── default.nix
│   ├── wezterm/               # Terminal configuration  
│   │   ├── default.nix        # Home Manager module (programs.wezterm config)
│   │   ├── wezterm.lua        # Application config files
│   │   └── themes/            # App-specific theme files (optional)
│   ├── waybar/                # Status bar
│   │   ├── default.nix        # Home Manager module (programs.waybar config)
│   │   ├── config.jsonc       # Waybar configuration
│   │   ├── style.css          # Waybar styles
│   │   └── modules/           # Custom waybar modules (optional)
│   ├── zsh/                   # Shell with p10k
│   ├── hyprland/              # Window manager
│   ├── mako/                  # Notifications
│   └── walker/               # Application launcher
│
├── bin/                       # Utility scripts (adapted from omarchy)
│   ├── omakase-theme-set      # Theme switching
│   ├── omakase-refresh-*      # Config refresh scripts
│   └── omakase-setup-*        # Setup utilities
│
├── config/                    # System configuration files (like omarchy/config)
│   ├── environment.d/         # Environment variables
│   └── systemd/              # User systemd services
│
├── modules/                   # Custom Home Manager modules (root level)
│   ├── desktop.nix            # Desktop environment setup
│   ├── development.nix        # Dev tools  
│   ├── hardware.nix           # Hardware support (brightness, bluetooth, etc.)
│   ├── audio.nix             # PipeWire user services
│   ├── themes.nix            # Theme management
│   └── default.nix           # Imports all modules
│
├── home/                     # Home Manager configurations
│   └── home.nix             # Main home configuration
│
├── themes/                   # Visual themes (from omarchy/lomarchy)
│   ├── catppuccin/
│   ├── tokyo-night/
│   ├── gruvbox/
│   └── ... (other themes)
│
└── docs/                    # Documentation
    ├── INSTALL.md          # Installation guide  
    ├── USAGE.md            # Usage instructions
    └── THEMES.md           # Theme guide
```

### Application Structure Pattern

Each application follows this pattern:
- **default.nix**: Home Manager module with `programs.app` configuration
- **Config files**: Application-specific configuration files (lua, json, css, etc.)
- **Optional folders**: themes/, modules/, plugins/ for complex applications

### Integration Flow

**Configuration Flow:**
```
flake.nix → home/home.nix → ../modules/default.nix → ../applications/*/default.nix
```

1. **home/home.nix** imports `../modules` (which loads `../modules/default.nix`)
2. **modules/default.nix** imports all application modules: `../applications/*/default.nix`
3. **Each application's default.nix** contains the Home Manager configuration and references local config files

### Implementation Workflow

1. **`boot.sh`**: Entry point that clones repo and calls install.sh (mirrors Omarchy pattern)
2. **`install.sh`**: 
   - **Prompt for username** with `$USER` as default for flexible installation
   - **Minimal base layer**: Install only `curl git` via apt (distribution-agnostic)
   - **Pure Nix approach**: Everything else through Nix/Home Manager for maximum portability
   - Set up Nix environment with proper channels and settings
   - Configure nixGL for GUI applications
   - Initialize Home Manager in flake mode for specified username
3. **`flake.nix`**: Main Home Manager configuration supporting any username
4. **Root-level modules**: System integration via user services (`modules/desktop.nix`, `modules/audio.nix`, etc.)
5. **Application modules**: Self-contained application configs in `applications/` directory
6. **Utility scripts**: Helper scripts in `bin/` for theme switching, config refresh, etc.

### Package Installation Strategy

**Minimal Base Layer (via distribution package manager):**
- **Bootstrap essentials only**: `curl git` 
- **Distribution-agnostic**: Works on Debian, Ubuntu, Fedora, openSUSE, Arch, etc.
- **First-class Debian support**: Tested and optimized for Debian-based systems

**Pure Nix Layer (via Home Manager unstable - everything else):**
- **System integration**: Audio (PipeWire), desktop portals, hardware support via user services
- **Hyprland desktop**: Bleeding-edge via official flake, full ecosystem  
- **Developer tools**: wezterm, nixvim with LSPs, devenv, direnv
- **Modern CLI experience**: bat, eza, ripgrep, fd, fzf, zoxide, btop
- **Shell environment**: zsh + modern prompt + developer plugins
- **User applications**: Latest versions with declarative configs
- **Hardware support**: Brightness, bluetooth, power management via Nix packages + user services

**Portability Benefits:** Same configuration works across all Linux distributions with zero modification

### Configuration Sources Integration (Priority Order)
1. **omarchy**: Primary source for configs, themes, keybindings, and aesthetic choices
2. **nix-home**: Reference for Nix module patterns and Home Manager integration  
3. **lomarchy**: Different applications NOT in omarchy that we decided to use
4. **dotfiles-nix**: Final fallback reference for Nix flake architecture patterns

### Target System Profile
- **OS**: Any Linux distribution (Debian-first, Ubuntu, Fedora, openSUSE, Arch compatible)
- **Username**: Flexible - prompts during installation with `$USER` as default
- **Display**: Hyprland (bleeding-edge via official flake)
- **Terminal**: WezTerm (GPU-accelerated, latest features)
- **Shell**: Zsh + modern prompt (developer-optimized)
- **Editor**: Neovim via nixvim (IDE-like experience)
- **Package Manager**: Pure Nix (unstable) + Home Manager approach
- **Target Audience**: Developers first, accessible to general users

## Application Inventory

> **Note**: This is the complete application list extracted from all source systems. Manual trimming needed to create the final Omakase application set.

### GUI Applications

#### Browsers & Web
- **firefox** (lomarchy, dotfiles-nix, debian)

#### Media & Graphics
- **mpv** (omarchy, debian)
- **imv** (lomarchy, omarchy, debian) - Image viewer
- **evince** (lomarchy, omarchy, debian) - PDF viewer
- **obs-studio** (lomarchy, omarchy, debian) - Screen recording
- **pinta** (omarchy, debian) - Image editor
- **satty** (omarchy) - Screenshot annotation

#### Office & Productivity
- **obsidian** (lomarchy, omarchy, dotfiles-nix)

#### Communication & Social
- **spotify** (lomarchy, omarchy)
- **discord** (dotfiles-nix)

#### File Management
- **nautilus** (lomarchy, omarchy, debian) - File manager
- **sushi** (lomarchy, omarchy, debian) - File previewer

#### System Utilities
- **gnome-calculator** (lomarchy, omarchy, debian)
- **pavucontrol** (lomarchy, debian) - Audio control
- **blueberry** (lomarchy, omarchy, debian) - Bluetooth manager
- **localsend** (omarchy) - File sharing
- **github-desktop** (dotfiles-nix)
- **vscode** (dotfiles-nix)

#### Gaming & Entertainment
- **steam** (via installation scripts)
- **protonup-qt** (dotfiles-nix) - Steam Proton manager

### Desktop Environment & Window Management

#### Wayland Compositor & Tools
- **hyprland** (lomarchy, omarchy, nix-home)
- **hyprshot** (lomarchy, omarchy, nix-home) - Screenshots
- **hyprpicker** (lomarchy, omarchy) - Color picker
- **hyprlock** (lomarchy, omarchy) - Screen locker
- **hypridle** (lomarchy, omarchy) - Idle daemon
- **hyprpolkitagent** (lomarchy)
- **hyprsunset** (omarchy) - Blue light filter
- **hyprland-qtutils** (lomarchy, omarchy)

#### Panels & Launchers
- **waybar** (lomarchy, omarchy, nix-home)
- **walker** (lomarchy) / **walker-bin** (omarchy) - Application launcher

#### Notifications & OSD
- **mako** (lomarchy, omarchy, nix-home) - Notification daemon
- **swayosd** (omarchy) - On-screen display

#### Clipboard & Background
- **wl-clipboard** (lomarchy, omarchy, nix-home)
- **wl-clip-persist** (lomarchy, omarchy)
- **clipse** (lomarchy) - Clipboard manager
- **swaybg** (lomarchy, omarchy, nix-home) - Background setter

#### Portal & Desktop Integration
- **xdg-desktop-portal-hyprland** (lomarchy, omarchy, debian)
- **xdg-desktop-portal-gtk** (lomarchy, omarchy, debian)

### Terminal & CLI Tools

#### Terminal Emulators
- **wezterm** (nix-home, dotfiles-nix)

#### Shell & Shell Enhancements
- **zsh** (lomarchy, omarchy, nix-home, dotfiles-nix, debian)
- **bash-completion** (omarchy, debian)
- **starship** (omarchy, debian) - Shell prompt

#### File Operations
- **bat** (all systems) - Better cat
- **eza** (nix-home, omarchy, dotfiles-nix) - Better ls
- **fd** / **fd-find** (omarchy, lomarchy) - Better find
- **ripgrep** (nix-home, omarchy) - Better grep
- **fzf** (lomarchy, omarchy) - Fuzzy finder
- **skim** (nix-home) - Fuzzy finder (Rust)
- **zoxide** (lomarchy, omarchy, dotfiles-nix) - Smart cd
- **duf** (dotfiles-nix) - Better df
- **ncdu** (dotfiles-nix) - Disk usage analyzer
- **tree-sitter-cli** (lomarchy, omarchy)

#### System Monitoring
- **btop** (lomarchy, omarchy, nix-home, dotfiles-nix) - System monitor
- **fastfetch** (lomarchy, omarchy, dotfiles-nix) - System info

#### Text Processing & Search
- **less** (lomarchy, omarchy, debian)
- **man** (lomarchy, omarchy, debian) - Manual pages
- **tldr** (lomarchy, omarchy, debian) - Simplified manuals
- **glow** (nix-home) - Markdown renderer

#### Network & Internet
- **wget** (debian)
- **curl** (lomarchy, dotfiles-nix, debian)
- **whois** (lomarchy, omarchy, debian)
- **inetutils** (lomarchy, debian)

#### Archive & Compression
- **unzip** (lomarchy, omarchy, debian)

### Development Tools

#### Version Control
- **git** (all systems, debian)
- **github-cli** / **gh** (lomarchy, omarchy, dotfiles-nix, debian)
- **lazygit** (lomarchy, omarchy, dotfiles-nix)

#### Editors
- **vim** (dotfiles-nix, debian)
- **nixvim** (nix-home) - Neovim via Nix

#### Programming Languages & Runtimes
- **uv**
- **python 3.13** (debian)
- **lua** (dotfiles-nix, debian)

#### Development Environment
- **devenv** (nix-home, dotfiles-nix) - Development environments
- **direnv** (nix-home, dotfiles-nix) - Environment switcher

#### Containerization
- **podman** (debian) - Rootless container engine, Docker-compatible
- **podman-compose** (debian) - Docker-compose alternative for Podman  
- **podman-docker** (debian) - Docker compatibility layer
- **lazydocker** (omarchy, dotfiles-nix) - Works with Podman via Docker API

### System & Hardware

#### Audio
- **wireplumber** (lomarchy, omarchy, debian)
- **pamixer** (lomarchy, omarchy, debian) - Audio mixer
- **playerctl** (lomarchy, omarchy, debian) - Media player control
- **wiremix** (omarchy, debian) - Audio mixer

#### Display & Brightness
- **brightnessctl** (lomarchy, omarchy, nix-home, debian)

#### Input Methods
- **fcitx5** (lomarchy, omarchy, debian)
- **fcitx5-gtk** (lomarchy, omarchy, debian)
- **fcitx5-qt** (lomarchy, omarchy, debian)
- **fcitx5-configtool** (lomarchy, omarchy, debian)
- **kmonad** (nix-home) - Keyboard customization

#### Networking
- **avahi** (omarchy, debian) - Network discovery
- **nss-mdns** (omarchy, debian) - Multicast DNS
- **iwd** (omarchy, debian) - WiFi daemon

#### Power Management
- **power-profiles-daemon** (lomarchy, omarchy, debian)

#### Security & Authentication
- **gnome-keyring** (omarchy, debian)
- **polkit-gnome** (omarchy, debian)
- **ufw** (omarchy, debian) - Firewall
- **ufw-docker** (omarchy, debian) - Docker firewall integration

### Media & Recording
- **wf-recorder** (omarchy, debian) - Wayland recorder
- **wl-screenrec** (omarchy) - Screen recorder
- **imagemagick** (lomarchy, omarchy, debian)
- **ffmpegthumbnailer** (omarchy, debian) - Video thumbnails

### Fonts & Theming

#### Fonts
- **fira-code-nerdfont** - Default monospace font
- **inter** (debian) - Primary sans-serif font for UI
- **source-sans-3** (debian) - Alternative sans-serif  
- **source-serif-4** (debian) - Serif font for documents
- **jetbrains-mono-nerdfont** - Alternative monospace
- **noto-fonts-core** (debian) - Universal coverage and fallbacks
- **noto-color-emoji** (debian) - Emoji support

#### Themes & Icons
- **gnome-themes-extra** (lomarchy, omarchy, debian)
- **kvantum-qt5** (lomarchy, omarchy, debian) - Qt theming
- **yaru-icon-theme** (omarchy, debian)

### Printing
- **cups** (lomarchy, omarchy, debian)
- **cups-pdf** (lomarchy, omarchy, debian)
- **cups-filters** (lomarchy, omarchy, debian)
- **cups-browsed** (omarchy, debian)
- **system-config-printer** (lomarchy, omarchy, debian)

### File Systems
- **gvfs-mtp** (omarchy, debian) - Mobile device access
- **gvfs-smb** (omarchy, debian) - Network share access
- **cifs-utils** (dotfiles-nix, debian) - Network filesystem

### Special Tools & Utilities
- **impala** (omarchy) - TUI file manager
- **slurp** (omarchy, debian) - Screen area selection
- **qt5-wayland** (omarchy, debian) - Qt Wayland support
- **tzupdate** (omarchy) - Timezone updater
- **plocate** (lomarchy, omarchy, debian) - File locator
- **gum** (omarchy) - Shell scripting utilities
- **libqalculate** (omarchy, debian) - Calculator library

### Web Applications (from omarchy)
Pre-configured web applications as desktop apps:
- **Google Photos** (photos.google.com)
- **Google Contacts** (contacts.google.com)
- **Google Messages** (messages.google.com/web/conversations)
- **Gemini** (gemini.google.com)
- **YouTube** (youtube.com)
- **GitHub** (github.com)

## Next Steps

1. **Application Curation**: Manually trim the above comprehensive list to create the final Omakase application set
2. **Core System Definition**: Define the essential applications that make up the base Omakase experience
3. **Configuration Architecture**: Plan how to structure the Nix modules for maintainability
4. **Testing Strategy**: Define testing approach for the installation and configuration process

## Success Criteria

- Single-command installation creates a fully functional, beautiful Debian desktop
- All configurations are declarative and version-controlled via Nix
- System feels modern and polished like Omarchy but runs on stable Debian
- Easy to modify and extend for personal preferences
- Reliable updates and rollbacks via Home Manager
- **Reusable Foundation**: Other flake-based configurations can import Omakase as a base module for instant Omarchy-style setup

### Reusable Flake Architecture

The end goal is to make `flake.nix` importable by other configurations:

```nix
# Example: dotfiles-nix importing Omakase as base
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager";
  omakase.url = "github:your-repo/omakase";
};

# Then use Omakase as foundation:
homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
  modules = [
    omakase.homeManagerModules.default  # Gets full Omarchy experience
    ./custom-overrides.nix              # User customizations
  ];
};
```