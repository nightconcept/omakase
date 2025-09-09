# Main home configuration - imports all modules
{ config, pkgs, lib, ... }:

{
  # Import all modules
  imports = [
    ../modules
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # User information
  home = {
    username = "danny";
    homeDirectory = "/home/danny";
    stateVersion = "23.11";
  };

  # Enable experimental features
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  # Basic packages that should always be available
  home.packages = with pkgs; [
    # System utilities
    tree
    file
    which
    wget
    curl
    unzip
    zip
    p7zip
    
    # Text processing
    less
    more
    
    # Network utilities
    iputils   # ping, traceroute, etc.
    nmap
    
    # Process management
    psmisc  # killall, pstree
    procps  # ps, top, etc.
    
    # Archive handling
    unrar
    
    # System information
    neofetch
    
    # Media
    imagemagick
    ffmpeg
  ];

  # Basic shell configuration
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    
    # XDG directories are set by xdg.enable = true;
    
    # Path additions
    PATH = "$PATH:$HOME/.local/bin:$HOME/bin";
  };

  # Basic aliases
  home.shellAliases = {
    # Safety
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    
    # Convenience
    ll = "ls -la";
    la = "ls -la";
    l = "ls -l";
    ".." = "cd ..";
    "..." = "cd ../..";
    
    # System
    df = "df -h";
    du = "du -h";
    free = "free -h";
    
    # Network
    ports = "netstat -tulanp";
    
    # Processes
    psg = "ps aux | grep -v grep | grep -i -e VSZ -e";
    
    # Quick editing
    zshrc = "nvim ~/.zshrc";
    vimrc = "nvim ~/.config/nvim/init.lua";
    
    # Home Manager
    hm = "home-manager";
    hms = "home-manager switch --flake ~/omakase#danny";
    hmb = "home-manager build --flake ~/omakase#danny";
    
    # Nix
    nix-gc = "nix-collect-garbage -d";
    nix-update = "cd ~/omakase && nix flake update";
  };

  # Enable systemd user services
  systemd.user.startServices = "sd-switch";

  # XDG user directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
    };
  };
}