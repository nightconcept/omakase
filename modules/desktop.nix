# Desktop environment setup (Hyprland, portals, etc.)
{ config, pkgs, lib, ... }:

{
  # Desktop portal configuration for Wayland/Hyprland
  home.packages = with pkgs; [
    # Desktop portals
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    
    # Hyprland ecosystem
    hyprland      # Wayland compositor
    hyprshot      # Screenshot tool for Hyprland
    hyprpicker    # Color picker for Hyprland
    hyprlock      # Screen locker for Hyprland
    hypridle      # Idle management for Hyprland
    
    # Screen capture and recording
    grim          # Screenshot utility
    slurp         # Region selector
    wl-clipboard  # Wayland clipboard utilities
    wl-clip-persist # Clipboard persistence
    
    # Status bar and notifications
    waybar        # Wayland status bar
    mako          # Notification daemon
    
    # Desktop utilities
    swaybg        # Wallpaper setter
    swaylock      # Screen locker
    swayidle      # Idle management
    
    # Application launcher
    wofi          # Wayland launcher
    
    # File manager integration
    nautilus      # GNOME file manager
    file-roller   # Archive manager
    
    # Media applications
    mpv           # Media player
    imv           # Image viewer
    
    # Browser
    firefox       # Web browser
    
    # Polkit authentication agent
    polkit_gnome  # Polkit agent for GUI authentication
  ];

  # XDG configuration
  xdg = {
    enable = true;
    
    # Desktop portal configuration
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
    
    # MIME type associations
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "inode/directory" = "nautilus.desktop";
      };
    };
  };

  # Session variables for Wayland
  home.sessionVariables = {
    # Wayland-specific
    WAYLAND_DISPLAY = "wayland-1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    
    # QT/GTK theming
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    
    # Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Systemd user services for desktop integration
  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}