{ pkgs }:

{
  # Packages that every environment gets
  packages = with pkgs; [
    # Core utilities
    git
    curl
    wget
    vim
    htop

    # Build essentials
    gnumake
    pkg-config

    # msfconsole dependencies
    ruby
    rubyPackages_3_4.racc
    rubyPackages_3_4.rbs
    rubyPackages_3_4.byebug

    # Useful for any dev work
    jq
    ripgrep
    fd

    # Version control helpers
    lazygit
  ];

  # Common shell hook that runs for all profiles
  shellHook = ''
    echo "Development environment loaded"
    echo "Available profiles: bughunting, python, rust, disassembly, c-dev, go-dev"
    echo ""

    # Set up common paths or variables
    export EDITOR="vim"
    export VISUAL="vim"

    # Color prompt
    export PS1='\[\033[1;34m\][nix-dev]\[\033[0m\] \w $ '
  '';

  # Common environment variables
  env = {
    # Add any shared env vars
  };
}
