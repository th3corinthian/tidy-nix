# Custom package overlays
# Use this to add custom packages or override existing ones

final: prev: {
  # Example: Add a custom script
  devenv-helper = prev.writeShellScriptBin "devenv-helper" ''
    echo "Available development environments:"
    echo "  nix develop .#bughunting   - Debugging and analysis tools"
    echo "  nix develop .#disassembly  - Disassembly and reverse engineering"
    echo "  nix develop .#c-dev        - C development environment"
    echo "  nix develop .#go-dev       - Go development environment"
    echo "  nix develop .#python       - Python development environment"
    echo "  nix develop .#rust         - Rust development environment"
  '';

  # Example: Override a package version
  # radare2 = prev.radare2.overrideAttrs (old: {
  #   version = "5.8.0";
  #   src = prev.fetchFromGitHub {
  #     owner = "radareorg";
  #     repo = "radare2";
  #     rev = "5.8.0";
  #     sha256 = "...";
  #   };
  # });
}
