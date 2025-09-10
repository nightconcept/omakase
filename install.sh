#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Exit with error message
die() {
    log_error "$1"
    exit 1
}

# Detect distribution and set appropriate package manager commands
detect_distribution() {
    if [[ ! -f /etc/os-release ]]; then
        die "Cannot detect distribution: /etc/os-release not found"
    fi
    
    source /etc/os-release
    log_info "Detected OS: $PRETTY_NAME"
    
    # Set package manager commands based on detected distribution
    if command -v apt >/dev/null 2>&1; then
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
    elif command -v apt-get >/dev/null 2>&1; then
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_UPDATE="dnf update -y"
        PKG_INSTALL="dnf install -y"
    elif command -v zypper >/dev/null 2>&1; then
        PKG_UPDATE="zypper refresh"
        PKG_INSTALL="zypper install -y"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_UPDATE="pacman -Sy"
        PKG_INSTALL="pacman -S --noconfirm"
    else
        die "Unsupported package manager. This script supports: apt, dnf, zypper, pacman"
    fi
}

# Prompt for username with validation
get_username() {
    local default_user="${USER}"
    read -p "Enter username to install Omakase for [$default_user]: " OMAKASE_USER
    OMAKASE_USER=${OMAKASE_USER:-$default_user}
    
    # Validate username exists
    if ! id "$OMAKASE_USER" &>/dev/null; then
        die "User '$OMAKASE_USER' does not exist on this system"
    fi
    
    log_info "Installing Omakase for user: $OMAKASE_USER"
}

# Check and install sudo if needed
check_sudo() {
    if ! command -v sudo &> /dev/null; then
        log_warning "sudo not found, installing..."
        case "$ID" in
            debian|ubuntu)
                su -c "$PKG_UPDATE && $PKG_INSTALL sudo"
                ;;
            *)
                die "sudo is required but not installed. Please install sudo and add $OMAKASE_USER to sudoers group"
                ;;
        esac
        
        log_warning "Please add $OMAKASE_USER to sudoers group and re-run this script:"
        echo "  su -c 'usermod -aG sudo $OMAKASE_USER'"
        exit 1
    fi
    
    # Check if user has sudo privileges
    if ! sudo -n -u "$OMAKASE_USER" true 2>/dev/null; then
        log_warning "User $OMAKASE_USER may not have sudo privileges"
        log_info "If installation fails, add user to sudoers: usermod -aG sudo $OMAKASE_USER"
    fi
}

# Install minimal base dependencies
install_base_packages() {
    log_info "Installing minimal base dependencies..."
    
    sudo $PKG_UPDATE || die "Failed to update package lists"
    sudo $PKG_INSTALL curl git || die "Failed to install base dependencies (curl, git)"
    
    log_success "Base dependencies installed"
}

# Install and configure Nix
install_nix() {
    log_info "Installing Nix package manager..."
    
    # Check if Nix is already installed
    if command -v nix &>/dev/null || [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] || [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        log_warning "Nix is already installed, skipping installation"
        # Source Nix if not already in PATH
        if ! command -v nix &>/dev/null; then
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
                source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
                source "$HOME/.nix-profile/etc/profile.d/nix.sh"
            fi
        fi
        return 0
    fi
    
    # Try Determinate Systems installer first (better for most cases)
    if curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --yes; then
        log_success "Nix installed successfully using Determinate Systems installer"
    else
        log_warning "Determinate Systems installer failed, trying official installer..."
        # Fallback to official installer with single-user mode for better compatibility
        if yes | sh <(curl -L https://nixos.org/nix/install) --no-daemon; then
            log_success "Nix installed successfully using official installer"
        else
            die "Failed to install Nix package manager"
        fi
    fi
}

# Configure Nix settings
configure_nix() {
    log_info "Configuring Nix settings..."
    
    # Create nix config directory
    mkdir -p ~/.config/nix
    
    # Configure trusted users (if using multi-user mode)
    if [[ -f /etc/nix/nix.conf ]]; then
        if ! grep -q "trusted-users.*$OMAKASE_USER" /etc/nix/nix.conf; then
            echo "trusted-users = root $OMAKASE_USER" | sudo tee -a /etc/nix/nix.conf >/dev/null
            log_info "Added $OMAKASE_USER to trusted users"
        fi
    fi
    
    # Add experimental features for flakes
    cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
auto-optimise-store = true
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
substituters = https://cache.nixos.org https://cache.iog.io
EOF
    
    # Source nix profile if available
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    elif [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
    fi
    
    log_success "Nix configuration completed"
}

# Set up Nix channels
setup_nix_channels() {
    log_info "Setting up Nix channels..."
    
    # Add unstable channel for latest packages
    nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
    
    # Update channels with retry and better error handling
    if ! nix-channel --update; then
        log_warning "Channel update failed, trying with --option tarball-ttl 0 to bypass cache..."
        nix-channel --update --option tarball-ttl 0 || die "Failed to update Nix channels"
    fi
    
    log_success "Nix channels configured"
}

# Install Home Manager
install_home_manager() {
    log_info "Installing Home Manager..."
    
    # Check if already installed
    if command -v home-manager &>/dev/null; then
        log_warning "Home Manager already installed, skipping"
        return 0
    fi
    
    # Install Home Manager using flakes (modern approach)
    if nix run home-manager/master -- init --switch; then
        log_success "Home Manager installed using flakes"
    else
        log_info "Flakes installation failed, trying channel-based installation..."
        nix-shell '<home-manager>' -A install || die "Failed to install Home Manager"
        log_success "Home Manager installed using channels"
    fi
}

# Install nixGL for GUI applications
install_nixgl() {
    log_info "Installing nixGL for GUI application support..."
    
    # Check if already installed
    if command -v nixGL &>/dev/null; then
        log_warning "nixGL already installed, skipping"
        return 0
    fi
    
    nix-env -iA nixgl.auto.nixGLDefault || die "Failed to install nixGL"
    
    log_success "nixGL installed successfully"
}

# Apply Home Manager configuration
apply_configuration() {
    log_info "Applying Home Manager configuration for $OMAKASE_USER..."
    
    # Verify flake.nix exists
    if [[ ! -f "flake.nix" ]]; then
        die "flake.nix not found. Please ensure you're in the omakase directory."
    fi
    
    # Check if configuration exists for user
    if ! nix flake show | grep -q "$OMAKASE_USER"; then
        log_warning "No configuration found for user '$OMAKASE_USER' in flake.nix"
        log_info "Available configurations:"
        nix flake show | grep homeConfigurations || log_warning "No homeConfigurations found"
        die "Please add a homeConfiguration for user '$OMAKASE_USER' to flake.nix"
    fi
    
    # Apply the configuration
    home-manager switch --flake ".#$OMAKASE_USER" || die "Failed to apply Home Manager configuration"
    
    log_success "Home Manager configuration applied successfully"
}

# Create update script
create_update_script() {
    log_info "Creating omakase update script..."
    
    local update_script="$HOME/.local/bin/omakase"
    mkdir -p "$(dirname "$update_script")"
    
    cat > "$update_script" << 'EOF'
#!/bin/bash
# Omakase update script

set -euo pipefail

OMAKASE_DIR="$HOME/omakase"

echo "🍣 Omakase Update"
echo "=================="

if [[ ! -d "$OMAKASE_DIR" ]]; then
    echo "Error: Omakase directory not found at $OMAKASE_DIR"
    exit 1
fi

cd "$OMAKASE_DIR"

echo "Updating flake inputs..."
nix flake update

echo "Applying Home Manager configuration..."
home-manager switch --flake ".#$(whoami)"

echo "Update complete! 🎉"
EOF
    
    chmod +x "$update_script"
    log_success "Update script created at $update_script"
}

# Print final instructions
print_completion() {
    echo
    log_success "🎉 Omakase installation completed for user: $OMAKASE_USER"
    echo
    log_info "Next steps:"
    echo "  1. Restart your terminal or source your shell config"
    echo "  2. To update in the future, run: omakase"
    echo "  3. Configuration files are in: $PWD"
    echo
    log_info "If you encounter GUI application issues, try running them with nixGL:"
    echo "  Example: nixGL firefox"
    echo
}

# Main installation function
main() {
    log_info "🍣 Starting Omakase installation..."
    echo
    
    detect_distribution
    get_username
    check_sudo
    install_base_packages
    install_nix
    configure_nix
    setup_nix_channels
    install_home_manager
    install_nixgl
    apply_configuration
    create_update_script
    print_completion
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi