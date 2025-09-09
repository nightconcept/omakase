# Hardware support (brightness, bluetooth, power management)
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Brightness control
    brightnessctl   # Brightness control utility
    
    # Bluetooth
    bluez           # Bluetooth stack
    bluez-tools     # Bluetooth utilities
    
    # Power management
    powertop        # Power consumption monitor
    acpi            # ACPI utilities
    
    # Audio hardware
    alsa-utils      # ALSA utilities
    pavucontrol     # PulseAudio volume control
    
    # Network hardware
    networkmanager  # Network management
    networkmanager-openvpn
    wirelesstools   # Wireless utilities (iwconfig, iwlist)
    iw              # Wireless configuration
    
    # USB and storage
    usbutils        # USB utilities (lsusb)
    udisks2         # Disk management
    
    # System information
    lshw            # Hardware lister
    hwinfo          # Hardware information
    pciutils        # PCI utilities (lspci)
    dmidecode       # DMI table decoder
    
    # Sensors
    lm_sensors      # Hardware sensors
    
    # Graphics
    glxinfo         # OpenGL information
    vulkan-tools    # Vulkan utilities
    
    # Webcam
    v4l-utils       # Video4Linux utilities
    
    # Printer support
    cups            # CUPS printing system
    system-config-printer  # Printer configuration GUI
  ];

  # Systemd user services for hardware management
  systemd.user.services = {
    # Bluetooth auto-connect service (if needed)
    bluetooth-auto-connect = {
      Unit = {
        Description = "Bluetooth auto-connect";
        After = [ "bluetooth.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bluez}/bin/bluetoothctl connect-device-auto";
        RemainAfterExit = true;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  # Hardware-specific session variables
  home.sessionVariables = {
    # Graphics
    LIBVA_DRIVER_NAME = "iHD"; # Intel hardware acceleration
    VDPAU_DRIVER = "va_gl";    # VDPAU via VAAPI
    
    # Wayland-specific
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland support
    
    # Input method
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx5";
  };

  # Hardware-related shell aliases
  home.shellAliases = {
    # Hardware information
    hw = "hwinfo --short";
    sensors = "sensors";
    lsblk = "lsblk -f";
    
    # Power management
    battery = "acpi -b";
    thermal = "acpi -t";
    
    # Network
    wifi = "nmcli dev wifi";
    bluetooth = "bluetoothctl";
    
    # USB
    lsusb = "lsusb";
    
    # Graphics
    glinfo = "glxinfo | grep -i vendor";
  };

  # XDG configuration for hardware integration
  xdg.configFile = {
    # Brightness control configuration
    "brightnessctl/brightnessctl.conf".text = ''
      # Brightnessctl configuration
      # Minimum brightness percentage
      min_brightness=5
    '';
  };

  # Services configuration
  services = {
    # Enable GNOME Keyring for hardware authentication
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };

  # Desktop entries for hardware utilities
  xdg.desktopEntries = {
    # Bluetooth manager
    blueman-manager = {
      name = "Bluetooth Manager";
      comment = "Manage Bluetooth devices";
      exec = "${pkgs.blueman}/bin/blueman-manager";
      icon = "bluetooth";
      categories = [ "Settings" "HardwareSettings" ];
    };
    
    # Network manager
    nm-connection-editor = {
      name = "Network Connections";
      comment = "Manage network connections";
      exec = "${pkgs.networkmanager}/bin/nm-connection-editor";
      icon = "network-workgroup";
      categories = [ "Settings" "HardwareSettings" ];
    };
    
    # System monitor
    btop = {
      name = "System Monitor";
      comment = "Resource usage monitor";
      exec = "${pkgs.btop}/bin/btop";
      icon = "utilities-system-monitor";
      categories = [ "System" "Monitor" ];
      terminal = true;
    };
  };
}