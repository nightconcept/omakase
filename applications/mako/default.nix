# Mako notification daemon configuration
{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    # TODO: Extract and convert from omarchy/lomarchy configurations
    # Configuration will include:
    # - Notification styling (Omarchy-inspired)
    # - Positioning and behavior
    # - Integration with Wayland/Hyprland
    # - Custom notification rules
  };
}