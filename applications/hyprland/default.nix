# Hyprland window manager configuration
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Basic configuration to prevent warnings
    # TODO: Extract full configuration from omarchy/lomarchy
    settings = {
      # Basic keybindings
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, wezterm"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, R, exec, walker"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
      ];
      
      # Basic styling
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";  # Tokyo Night blue/purple
        "col.inactive_border" = "rgba(414868aa)";  # Tokyo Night overlay
        layout = "dwindle";
        allow_tearing = false;
      };
      
      # Tokyo Night color scheme
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      
      # Misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
    };
  };
}