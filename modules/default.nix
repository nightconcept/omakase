# Main module configuration - imports all modules and applications
{ config, pkgs, lib, ... }:

{
  imports = [
    # Core modules
    ./desktop.nix
    ./development.nix
    ./hardware.nix
    ./audio.nix
    ./themes.nix
    
    # Applications
    ../applications/nixvim
    ../applications/wezterm
    ../applications/waybar
    ../applications/zsh
    ../applications/hyprland
    ../applications/mako
    ../applications/walker
  ];
}