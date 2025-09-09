#!/bin/bash
set -euo pipefail

# Omakase Bootstrap Script
# Detects Debian-based OS and initializes the installation process

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII art
ansi_art='                      ▄▄▄                                                   
     ■                    ■        ■■                   
     ■                    ■     ■■■■            ■      ■     
     ■      ■■           ■■ ■■■■■               ■      ■     
     ■■■■■   ■■          ■      ■               ■      ■     
 ■■■■■        ■         ■■      ■               ■      ■     
     ■                  ■       ■           ■■■■■■■■■■■■■■■■ 
     ■                 ■■       ■               ■      ■     
     ■ ■■■■■■         ■ ■  ■■■■■■■■■■■          ■      ■     
     ■■■    ■■          ■       ■               ■      ■     
   ■■■       ■■         ■       ■               ■      ■     
  ■■ ■        ■         ■       ■               ■    ■■      
 ■■  ■        ■         ■       ■               ■            
 ■   ■       ■■         ■       ■               ■            
 ■  ■■      ■■          ■       ■                ■           
  ■■■     ■■■           ■   ■■■■■■■■■             ■■■■■■■■   
                        ■                               
 ██████  ███    ███  █████  ██   ██  █████  ███████ ███████ 
██    ██ ████  ████ ██   ██ ██  ██  ██   ██ ██      ██      
██    ██ ██ ████ ██ ███████ █████   ███████ ███████ █████   
██    ██ ██  ██  ██ ██   ██ ██  ██  ██   ██      ██ ██      
 ██████  ██      ██ ██   ██ ██   ██ ██   ██ ███████ ███████ '

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

# Detect OS and distribution
detect_os() {
    if [[ ! -f /etc/os-release ]]; then
        die "Cannot detect OS: /etc/os-release not found"
    fi
    
    source /etc/os-release
    
    # Check if it's Debian-based
    case "$ID" in
        debian|ubuntu|pop|linuxmint|elementary|zorin)
            log_success "Detected Debian-based OS: $PRETTY_NAME"
            ;;
        *)
            case "$ID_LIKE" in
                *debian*|*ubuntu*)
                    log_success "Detected Debian-based OS: $PRETTY_NAME"
                    ;;
                *)
                    die "Unsupported OS: $PRETTY_NAME. Omakase currently supports Debian-based systems only."
                    ;;
            esac
            ;;
    esac
    
    # Detect package manager
    if command -v apt >/dev/null 2>&1; then
        PKG_MANAGER="apt"
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
    elif command -v apt-get >/dev/null 2>&1; then
        PKG_MANAGER="apt-get" 
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y"
    else
        die "No supported package manager found (apt/apt-get)"
    fi
    
    log_info "Using package manager: $PKG_MANAGER"
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        die "Do not run this script as root. Run as a regular user with sudo privileges."
    fi
    
    # Check sudo access
    if ! sudo -n true 2>/dev/null; then
        log_info "Testing sudo access..."
        sudo true || die "This script requires sudo privileges"
    fi
    
    # Check internet connectivity
    if ! ping -c 1 google.com >/dev/null 2>&1; then
        die "Internet connection required but not available"
    fi
    
    log_success "System requirements check passed"
}

# Install minimal dependencies
install_dependencies() {
    log_info "Installing minimal bootstrap dependencies..."
    
    sudo $PKG_UPDATE || die "Failed to update package lists"
    sudo $PKG_INSTALL curl git || die "Failed to install bootstrap dependencies"
    
    log_success "Bootstrap dependencies installed"
}

# Clone omakase repository
clone_repository() {
    # Use custom repo if specified, otherwise default to dannyo/omakase
    local repo_url="https://github.com/${OMAKASE_REPO:-dannyo/omakase}.git"
    local target_dir="$HOME/omakase"
    
    log_info "Cloning omakase repository from: $repo_url"
    
    if [[ -d "$target_dir" ]]; then
        log_warning "Directory $target_dir already exists"
        read -p "Remove existing directory and continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$target_dir"
        else
            die "Installation cancelled"
        fi
    fi
    
    git clone "$repo_url" "$target_dir" || die "Failed to clone repository"
    
    # Use custom branch if instructed, otherwise default to main
    local branch="${OMAKASE_REF:-main}"
    if [[ "$branch" != "main" ]]; then
        log_info "Switching to branch: $branch"
        cd "$target_dir"
        git fetch origin "$branch" && git checkout "$branch" || die "Failed to switch to branch $branch"
        cd -
    fi
    
    log_success "Repository cloned to $target_dir"
}

# Run install script
run_install() {
    local install_script="$HOME/omakase/install.sh"
    
    if [[ ! -f "$install_script" ]]; then
        die "Install script not found at $install_script"
    fi
    
    log_info "Running installation script..."
    cd "$HOME/omakase"
    bash "$install_script" || die "Installation script failed"
    
    log_success "Installation completed successfully!"
}

# Print final instructions
print_instructions() {
    echo
    log_success "🎉 Omakase bootstrap completed!"
    echo
    log_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. To update in the future, run: omakase update"
    echo "  3. Configuration files are in: ~/omakase/"
    echo
    log_info "Enjoy your Omarchy-inspired developer environment!"
}

# Main execution
main() {
    clear
    echo -e "\n$ansi_art\n"
    echo "🍣 Omakase Bootstrap Script for Debian-based Systems"
    echo "====================================================="
    echo
    
    detect_os
    check_requirements
    install_dependencies
    clone_repository
    run_install
    print_instructions
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
