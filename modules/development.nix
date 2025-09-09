# Development tools and environment
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Version control
    git
    lazygit
    gh              # GitHub CLI
    git-lfs
    
    # Development environments
    devenv          # Development environment manager
    direnv          # Environment variable management
    nix-direnv      # Better direnv integration with Nix
    
    # Build tools and package managers
    uv              # Python package manager (fast pip replacement)
    nodejs_20       # Node.js runtime
    yarn            # JavaScript package manager
    pnpm            # Fast JavaScript package manager
    
    # Container tools
    podman          # Container runtime
    podman-compose  # Docker Compose for Podman
    lazydocker      # TUI for container management
    
    # Code utilities
    tree-sitter     # Syntax highlighting parser
    ripgrep         # Fast text search
    fd              # Fast find alternative
    bat             # Better cat
    eza             # Better ls
    fzf             # Fuzzy finder
    jq              # JSON processor
    yq-go           # YAML processor
    
    # System monitoring and debugging
    btop            # System monitor
    htop            # Process viewer
    strace          # System call tracer
    ltrace          # Library call tracer
    
    # Documentation and notes
    glow            # Markdown renderer
    mdcat           # Markdown cat
    
    # Network tools
    curl
    wget
    httpie          # HTTP client
    
    # Database tools
    sqlite          # SQLite database
    
    # Language servers and formatters (for nixvim)
    nil             # Nix language server
    nixpkgs-fmt     # Nix formatter
    shellcheck      # Shell script linter
    shfmt           # Shell script formatter
    
    # Productivity
    tmux            # Terminal multiplexer
    zoxide          # Smart cd replacement
    fastfetch       # System information
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Danny O";
    userEmail = "danny@example.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      rerere.enabled = true;
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      
      # Pretty log
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      
      # Show files in last commit
      dl = "!git ll -1";
      
      # Short log
      ll = "log --pretty=format:' %C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate --numstat";
    };
  };

  # Direnv configuration
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Enable development services
  services = {
    # SSH agent
    ssh-agent.enable = true;
  };

  # Session variables for development
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "wezterm";
    
    # Development paths
    GOPATH = "$HOME/go";
    
    # Python development
    UV_CACHE_DIR = "$HOME/.cache/uv";
    
    # Node.js
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    
    # Rust
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
  };

  # Development shell aliases
  home.shellAliases = {
    # Git shortcuts
    g = "git";
    ga = "git add";
    gc = "git commit";
    gco = "git checkout";
    gd = "git diff";
    gl = "git pull";
    gp = "git push";
    gs = "git status";
    
    # Container shortcuts
    d = "podman";
    dc = "podman-compose";
    
    # Development tools
    lg = "lazygit";
    ld = "lazydocker";
    
    # Modern replacements
    cat = "bat";
    ls = "eza";
    find = "fd";
    grep = "rg";
    cd = "z";  # zoxide integration
  };
}