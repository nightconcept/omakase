# Walker application launcher configuration
{ config, pkgs, lib, ... }:

{
  # Walker package
  home.packages = with pkgs; [
    walker  # Application launcher for Wayland
  ];

  # TODO: Extract and convert from omarchy/lomarchy configurations
  # Configuration will include:
  # - Custom styling (Omarchy-inspired)
  # - Application search and launch
  # - Integration with Hyprland
  # - Custom key bindings
  
  xdg.configFile = {
    "walker/config.json".text = builtins.toJSON {
      # Basic walker configuration placeholder
      # Will be expanded with full configuration
    };
  };
}