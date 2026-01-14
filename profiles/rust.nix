{ pkgs, commonEnv, lib }:

{
  packages = with pkgs; [
    # Build dependencies
    pkg-config
    openssl
    cmake
    gcc

    # Debugging and profiling
    lldb                 # LLVM debugger
    cargo-flamegraph     # Flamegraph generator
    bacon                # Background code checker
    cargo-edit           # Dependency management
    cargo-watch          # Run commands on file changes
    cargo-audit          # Security audit
    cargo-deny           # Dependency linting
    cargo-outdated       # Check for outdated dependencies
    cargo-release        # Release automation
    cargo-tarpaulin      # Code coverage
    cargo-udeps          # Find unused dependencies

    # Documentation
    #rust-docs            # Offline Rust documentation
    rustup
    rustc

    # Utilities
    just                 # Command runner
    git
    nushell              # Modern shell (optional)
    zellij               # Terminal multiplexer (optional)
  ];

  # Platform-specific dependencies
  platformTools = with pkgs;
    if stdenv.isLinux then [
      # Linux-specific tools
      valgrind
      strace
      lsof
      # X11/Wayland dependencies for GUI applications
      libxkbcommon
      wayland
    ] else if stdenv.isDarwin then [
      # macOS-specific tools
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
      darwin.apple_sdk.frameworks.CoreFoundation
    ] else [ ];

  # Environment variables
  env = {
    # Enable backtraces by default
    RUST_BACKTRACE = "1";
    # Use mold linker if available (much faster linking)
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };

  # Shell hook for setup
  shellHook = ''
            echo "🚀 Rust development environment activated!"
            echo "📦 Rust version: $(rustc --version)"
            echo "🔧 Available tools:"
            echo "   • rustc, cargo, rustup"
            echo "   • rust-analyzer (LSP)"
            echo "   • clippy (linter)"
            echo "   • rustfmt (formatter)"
            echo "   • cargo watch, edit, audit, etc."

            # Create .cargo/config.toml if it doesn't exist
            if [ ! -f .cargo/config.toml ]; then
              mkdir -p .cargo
              cat > .cargo/config.toml << EOF
            [build]
            rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]

            [target.x86_64-unknown-linux-gnu]
            rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
            EOF
              echo "⚡ Created .cargo/config.toml with mold linker configuration"
            fi

            # Set up rust-analyzer configuration
            mkdir -p .vscode
            cat > .vscode/settings.json << EOF
            {
              "rust-analyzer.check.command": "clippy",
              "rust-analyzer.rustfmt.extraArgs": ["+nightly"],
              "rust-analyzer.linkedProjects": [
                "./Cargo.toml"
              ]
            }
            EOF
  '';
}
