# Package Installation Matrix

This document outlines the installation strategy for packages in Omakase, following the Pure Nix approach with minimal base layer.

## Installation Strategy

### Minimal Base Layer (Distribution Package Manager)
Only install absolute essentials via the distribution's package manager:

```bash
# Debian/Ubuntu
sudo apt install -y curl git

# Fedora  
sudo dnf install -y curl git

# openSUSE
sudo zypper install -y curl git

# Arch
sudo pacman -S curl git
```

### Everything Else via Nix
All other packages are installed through Home Manager and Nix packages for:
- Latest versions
- Declarative configuration
- User-level installation
- Easy rollback capability

## Package Categories

| Package | Debian Base | Nix | Module Location | Reason |
|---------|-------------|-----|-----------------|---------|
| **Bootstrap Essentials** |
| curl | ✓ | | Base layer | Required for Nix installation |
| git | ✓ | | Base layer | Required for repo cloning |
| **Desktop Environment** |
| hyprland | | ✓ | modules/desktop.nix | Latest features, Wayland compositor |
| waybar | | ✓ | modules/desktop.nix | Status bar with latest features |
| mako | | ✓ | modules/desktop.nix | Modern notification daemon |
| wofi | | ✓ | modules/desktop.nix | Wayland launcher |
| hyprshot | | ✓ | modules/desktop.nix | Hyprland-specific screenshot tool |
| hyprpicker | | ✓ | modules/desktop.nix | Hyprland-specific color picker |
| hyprlock | | ✓ | modules/desktop.nix | Hyprland-specific screen locker |
| hypridle | | ✓ | modules/desktop.nix | Hyprland-specific idle management |
| **System Integration** |
| xdg-desktop-portal-hyprland | | ✓ | modules/desktop.nix | Hyprland portal integration |
| xdg-desktop-portal-gtk | | ✓ | modules/desktop.nix | GTK portal integration |
| polkit_gnome | | ✓ | modules/desktop.nix | Authentication agent |
| **File Management** |
| nautilus | | ✓ | modules/desktop.nix | GNOME file manager integration |
| file-roller | | ✓ | modules/desktop.nix | Archive management |
| **Media Applications** |
| firefox | | ✓ | modules/desktop.nix | Latest browser features |
| mpv | | ✓ | modules/desktop.nix | Modern media player |
| imv | | ✓ | modules/desktop.nix | Wayland image viewer |
| **Terminal and Shell** |
| wezterm | | ✓ | applications/wezterm | Latest terminal features, GPU acceleration |
| zsh | | ✓ | applications/zsh | Modern shell with customization |
| **Development Tools** |
| lazygit | | ✓ | modules/development.nix | Modern Git TUI |
| devenv | | ✓ | modules/development.nix | Development environment manager |
| direnv | | ✓ | modules/development.nix | Environment variable management |
| uv | | ✓ | modules/development.nix | Fast Python package manager |
| nodejs_20 | | ✓ | modules/development.nix | JavaScript runtime |
| podman | | ✓ | modules/development.nix | Container runtime |
| **Modern CLI Tools** |
| bat | | ✓ | modules/development.nix | Better cat with syntax highlighting |
| eza | | ✓ | modules/development.nix | Better ls with colors |
| ripgrep | | ✓ | modules/development.nix | Faster grep replacement |
| fd | | ✓ | modules/development.nix | Better find alternative |
| fzf | | ✓ | modules/development.nix | Fuzzy finder |
| zoxide | | ✓ | modules/development.nix | Smart cd replacement |
| btop | | ✓ | modules/development.nix | Modern system monitor |
| fastfetch | | ✓ | modules/development.nix | System information |
| **Fonts** |
| fira-code-nerdfont | | ✓ | applications/wezterm | Nerd Font variants |
| jetbrains-mono-nerdfont | | ✓ | applications/wezterm | Nerd Font variants |
| **System Utilities** |
| grim | | ✓ | modules/desktop.nix | Wayland screenshot utility |
| slurp | | ✓ | modules/desktop.nix | Region selector |
| wl-clipboard | | ✓ | modules/desktop.nix | Wayland clipboard |
| swaybg | | ✓ | modules/desktop.nix | Wallpaper setter |

## Benefits of This Approach

### Minimal System Dependencies
- Only essential bootstrap tools via system package manager
- Reduced conflicts between system and user packages
- Easier to maintain across different distributions

### Pure Nix Advantages  
- **Latest Versions**: nixpkgs-unstable provides cutting-edge packages
- **Declarative**: All configurations version-controlled and reproducible  
- **User-level**: No system-wide changes, safer to experiment
- **Atomic**: Apply all changes at once or rollback entirely
- **Consistent**: Same packages and versions across all machines

### Distribution Agnostic
- Works on Debian, Ubuntu, Pop!_OS, and other Debian-based systems
- Minimal reliance on distribution-specific packages
- Easy to adapt to other Linux distributions in the future

## Integration Points

### System Services
- PipeWire audio configured via user config files
- Desktop portals configured through Home Manager
- Polkit agent as user systemd service

### Theme Integration
- All applications configured with Tokyo Night theme
- GTK and Qt theming handled by Home Manager
- Consistent fonts across all applications

### Development Workflow
- Modern CLI tools replace traditional commands
- Integrated development environment via nixvim
- Container development with podman
- Environment management with direnv and devenv