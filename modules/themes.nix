# Theme management and switching
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Theme utilities
    lxappearance           # GTK theme switcher
    libsForQt5.qt5ct      # Qt5 configuration tool
    qt6Packages.qt6ct     # Qt6 configuration tool
    
    # GTK themes
    tokyo-night-gtk # Tokyo Night GTK theme
    
    # Icon and cursor themes
    papirus-icon-theme
    adwaita-icon-theme  # Includes both icons and Adwaita cursor theme
    bibata-cursors
    
    # Font management
    font-manager
    
    # Color utilities
    gcolor3        # Color picker
    gpick          # Advanced color picker
    
    # Programming fonts
    fira-code
    fira-code-symbols
    fira-code-nerdfont
    jetbrains-mono
    
    # System fonts
    inter
    roboto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    
    # Icon fonts
    font-awesome
    nerd-fonts.fira-code    # FiraCode Nerd Font
    nerd-fonts.jetbrains-mono  # JetBrains Mono Nerd Font
  ];

  # Font configuration
  fonts.fontconfig.enable = true;

  # GTK theme configuration
  gtk = {
    enable = true;
    
    font = {
      name = "Inter";
      size = 11;
    };
    
    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyo-night-gtk;
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true
    '';
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
    };
  };

  # Qt theme configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk";  # Use GTK theme for Qt apps
    style = {
      name = "gtk2";
      package = pkgs.libsForQt5.qtstyleplugins;
    };
  };

  # Color scheme variables (for applications to use)
  home.sessionVariables = {
    # Theme preference
    GTK_THEME = "Tokyonight-Dark-BL";
    QT_STYLE_OVERRIDE = "gtk2";
    
    # Tokyo Night color scheme
    OMAKASE_COLOR_BASE = "#1a1b26";       # Tokyo Night background
    OMAKASE_COLOR_SURFACE = "#24283b";    # Tokyo Night surface
    OMAKASE_COLOR_OVERLAY = "#414868";    # Tokyo Night overlay
    OMAKASE_COLOR_TEXT = "#c0caf5";       # Tokyo Night foreground
    OMAKASE_COLOR_ACCENT = "#7aa2f7";     # Tokyo Night blue
    OMAKASE_COLOR_PRIMARY = "#bb9af7";    # Tokyo Night purple
    OMAKASE_COLOR_SUCCESS = "#9ece6a";    # Tokyo Night green
    OMAKASE_COLOR_WARNING = "#e0af68";    # Tokyo Night yellow
    OMAKASE_COLOR_ERROR = "#f7768e";      # Tokyo Night red
    OMAKASE_COLOR_CYAN = "#7dcfff";       # Tokyo Night cyan
    OMAKASE_COLOR_MAGENTA = "#bb9af7";    # Tokyo Night magenta
    OMAKASE_COLOR_ORANGE = "#ff9e64";     # Tokyo Night orange
  };

  # XDG configuration for consistent theming
  xdg.configFile = {
    # Fontconfig for better font rendering
    "fontconfig/fonts.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <alias>
          <family>monospace</family>
          <prefer>
            <family>FiraCode Nerd Font</family>
            <family>Fira Code</family>
            <family>JetBrains Mono</family>
          </prefer>
        </alias>
        <alias>
          <family>sans-serif</family>
          <prefer>
            <family>Inter</family>
            <family>Roboto</family>
            <family>Noto Sans</family>
          </prefer>
        </alias>
        <alias>
          <family>serif</family>
          <prefer>
            <family>Noto Serif</family>
          </prefer>
        </alias>
      </fontconfig>
    '';
    
    # Qt5/Qt6 configuration
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=
      custom_palette=false
      standard_dialogs=gtk3
      style=gtk2
      
      [Fonts]
      fixed="FiraCode Nerd Font,11,-1,5,50,0,0,0,0,0"
      general="Inter,11,-1,5,50,0,0,0,0,0"
      
      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=3
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3
    '';
    
    # MIME type associations for theme-aware applications
    "mimeapps.list".text = ''
      [Default Applications]
      image/svg+xml=inkscape.desktop
      image/png=imv.desktop
      image/jpeg=imv.desktop
      image/gif=imv.desktop
      image/webp=imv.desktop
      text/plain=nvim.desktop
      application/pdf=firefox.desktop
      
      [Added Associations]
      image/svg+xml=inkscape.desktop;
      image/png=imv.desktop;
      image/jpeg=imv.desktop;
      image/gif=imv.desktop;
      image/webp=imv.desktop;
      text/plain=nvim.desktop;
      application/pdf=firefox.desktop;
    '';
  };

  # Theme switching aliases
  home.shellAliases = {
    # Theme management
    theme-tokyo = "gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Dark-BL' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'";
    theme-light = "gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Light-BL' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'";
    theme-dark = "gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Dark-BL' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'";
    
    # Font management
    fonts = "fc-list : family | sort | uniq";
    font-cache = "fc-cache -fv";
    
    # Color utilities
    colors = "msgcat --color=test";
    colorpicker = "gcolor3";
  };

  # Font cache management is handled by fonts.fontconfig.enable above
}