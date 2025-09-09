# WezTerm configuration
{ config, pkgs, lib, ... }:

{
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    
    # Basic WezTerm configuration with Tokyo Night theme
    extraConfig = ''
      local config = {}
      
      -- Color scheme - Tokyo Night
      config.color_scheme = "Tokyo Night"
      
      -- Font configuration
      config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
      config.font_size = 12.0
      
      -- Window appearance
      config.window_background_opacity = 0.95
      config.window_decorations = "RESIZE"
      config.window_padding = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8,
      }
      
      -- Tab bar
      config.enable_tab_bar = true
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = true
      
      -- Performance
      config.max_fps = 60
      config.front_end = "WebGpu"
      
      -- Key bindings
      config.keys = {
        -- Split panes
        { key = "\\", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
        { key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
        
        -- Navigate panes
        { key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Left" },
        { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Right" },
        { key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Up" },
        { key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Down" },
        
        -- Close pane
        { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane { confirm = true } },
      }
      
      return config
    '';
  };
  
  # Ensure required fonts are available
  home.packages = with pkgs; [
    wezterm
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];
}