# Omakase Product Requirements Document (PRD)

## Project Overview

**Omakase** is an opinionated Debian configuration system that brings the aesthetic and functional appeal of Omarchy to stable Debian systems using Nix and Home Manager for reliable package and configuration management.

## Goals

1. **Stability First**: Use Debian as the base OS for rock-solid system reliability
2. **Aesthetic Excellence**: Replicate the visual appeal and modern feel of Omarchy/Lomarchy
3. **Declarative Management**: Leverage Nix/Home Manager for reproducible, version-controlled configurations
4. **Easy Deployment**: Single-command installation and updates
5. **Curated Experience**: Provide an opinionated but excellent default setup

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

### Implementation Workflow

1. **`boot.sh`**: Entry point that clones repo and calls install.sh (mirrors Omarchy pattern, adapted for Debian)
2. **`install.sh`**: 
   - Install essential Debian packages via apt (system integration critical packages)
   - Set up Nix environment with proper channels and settings
   - Configure nixGL for GUI applications
   - Initialize Home Manager in flake mode
3. **`flake.nix`**: Main Home Manager configuration defining user-space applications and configurations
4. **Nix modules**: Modular configuration structure for desktop environment, applications, and development tools

### Package Installation Strategy

**Debian Base Layer (via apt - distribution agnostic):**
- Core system integration: audio (pipewire/wireplumber), desktop portals, bluetooth
- Security foundation: gnome-keyring, polkit, ufw firewall
- Hardware support: brightness control, power management
- Essential utilities: git, curl, basic shell tools
- System fonts: Inter, Source Sans/Serif, Noto (universal coverage)
- Development foundation: python3, lua, podman

**Nix Layer (via Home Manager unstable - latest everything):**
- Hyprland desktop: bleeding-edge via official flake, full ecosystem
- Developer tools: wezterm, nixvim with LSPs, devenv, direnv
- Modern CLI experience: bat, eza, ripgrep, fd, fzf, zoxide, btop
- Shell environment: oh-my-zsh + starship + developer plugins
- User applications: latest versions with declarative configs

**Migration Strategy:** Detect and adapt to different Debian-based distributions (apt detection, package name variations, service management differences)

### Configuration Sources Integration
- **omarchy/lomarchy**: Extract themes, keybindings, application-specific configs, and aesthetic choices  
- **dotfiles-nix**: Reference for proper Nix flake architecture and Home Manager patterns
- **nix-home**: Working example of Hyprland on Debian via Nix for technical implementation

### Target System Profile
- **OS**: Debian-based systems (Debian 12+, Ubuntu 22.04+, future compatibility)
- **Display**: Hyprland (bleeding-edge via official flake)
- **Terminal**: WezTerm (GPU-accelerated, latest features)
- **Shell**: Zsh + Oh My Zsh + Starship (developer-optimized)
- **Editor**: Neovim via nixvim (IDE-like experience)
- **Package Manager**: Nix (unstable) + Home Manager (latest everything)
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