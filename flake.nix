{
  description = "Omakase - Opinionated Debian configuration with Nix and Home Manager";

  inputs = {
    # Core inputs - bleeding edge everything
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    
    # Home Manager - latest features
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Modern Neovim experience
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland compositor - absolute latest
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland plugins
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    
    # Modern development environments
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nix utilities
    flake-utils.url = "github:numtide/flake-utils";
    
    # Additional community packages
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NixGL for graphics on non-NixOS
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Catppuccin themes
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixvim,
    hyprland,
    hyprland-plugins,
    devenv,
    flake-utils,
    nixpkgs-wayland,
    nixgl,
    catppuccin,
    ...
  }:
    let
      # Supported systems
      systems = [ "x86_64-linux" "aarch64-linux" ];
      
      # Helper function to generate configurations for each system
      forEachSystem = nixpkgs.lib.genAttrs systems;
      
      # System-specific package sets
      pkgsFor = system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
        overlays = [
          # Wayland packages overlay
          nixpkgs-wayland.overlays.default
          
          # NixGL overlay
          nixgl.overlays.default
          
          # Custom overlay for Omakase-specific packages
          (final: prev: {
            omakase = {
              # Custom scripts and utilities will go here
              version = self.rev or "dirty";
            };
          })
        ];
      };
      
      # Stable packages for fallback
      stablePkgsFor = system: import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      
      # Special arguments passed to all modules
      extraSpecialArgs = system: {
        inherit inputs;
        pkgs-stable = stablePkgsFor system;
        system-config = {
          username = "danny";  # Default username, can be overridden
          homeDirectory = "/home/danny";
          omakaseDirectory = "/home/danny/omakase";
        };
      };
      
      # Home Manager configuration factory
      mkHomeConfiguration = { system, username ? "danny", homeDirectory ? "/home/${username}" }: 
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          
          # Pass extra arguments to modules
          extraSpecialArgs = (extraSpecialArgs system) // {
            system-config = {
              inherit username homeDirectory;
              omakaseDirectory = "${homeDirectory}/omakase";
            };
          };
          
          modules = [
            # Core Home Manager modules
            ./home/home.nix
            
            # Nixvim integration
            nixvim.homeModules.nixvim
            
            # Hyprland integration
            hyprland.homeManagerModules.default
            
            # Catppuccin themes
            catppuccin.homeModules.catppuccin
            
            # System-specific configuration
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "23.11";  # Pin state version for stability
              };
              
              # Enable experimental features
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
              
              # Allow unfree packages
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
    in
    {
      # Home Manager configurations
      homeConfigurations = {
        # Default configuration for "danny"
        danny = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "danny";
        };
        
        # Generic configuration template (can be customized)
        template = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "user";
          homeDirectory = "/home/user";
        };
      };
      
      # Development shells for different architectures
      # Temporarily disabled due to dependency issues
      # devShells = forEachSystem (system: {
      #   default = pkgs.mkShell {
      #     name = "omakase-dev";
      #   };
      # });
      
      # Packages for each system
      packages = forEachSystem (system:
        let
          pkgs = pkgsFor system;
        in
        {
          # Custom omakase update script
          omakase-update = pkgs.writeShellScriptBin "omakase-update" ''
            #!${pkgs.bash}/bin/bash
            set -euo pipefail
            
            OMAKASE_DIR="''${OMAKASE_DIR:-$HOME/omakase}"
            USERNAME="''${USERNAME:-$(whoami)}"
            
            echo "🍣 Omakase Update"
            echo "================"
            echo "Updating configuration for user: $USERNAME"
            echo "Omakase directory: $OMAKASE_DIR"
            echo
            
            if [[ ! -d "$OMAKASE_DIR" ]]; then
              echo "Error: Omakase directory not found at $OMAKASE_DIR"
              echo "Set OMAKASE_DIR environment variable to the correct path"
              exit 1
            fi
            
            cd "$OMAKASE_DIR"
            
            echo "Updating flake inputs..."
            ${pkgs.nix}/bin/nix flake update
            
            echo "Building Home Manager configuration..."
            ${pkgs.home-manager}/bin/home-manager build --flake ".#$USERNAME" --show-trace
            
            echo "Applying Home Manager configuration..."
            ${pkgs.home-manager}/bin/home-manager switch --flake ".#$USERNAME" --show-trace
            
            echo "Cleaning up old generations..."
            ${pkgs.nix}/bin/nix-collect-garbage -d
            
            echo
            echo "Update complete! 🎉"
            echo "Configuration applied for user: $USERNAME"
          '';
          
          # Install script package
          omakase-install = pkgs.writeShellScriptBin "omakase-install" (builtins.readFile ./install.sh);
          
          # Bootstrap script package  
          omakase-bootstrap = pkgs.writeShellScriptBin "omakase-bootstrap" (builtins.readFile ./boot.sh);
        });
      
      # Development templates
      templates = {
        default = {
          path = ./.;
          description = "Omakase configuration template";
        };
      };
      
      # Formatter for each system
      formatter = forEachSystem (system: (pkgsFor system).nixpkgs-fmt);
      
      # Checks for CI/testing (temporarily disabled due to store path issues)
      # checks = forEachSystem (system:
      #   let
      #     pkgs = pkgsFor system;
      #   in
      #   {
      #     # Check that the configuration builds  
      #     home-manager-danny = self.homeConfigurations.danny.activationPackage;
      #   });
      
    };
}
