{
  description = "Development environment profiles collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # Apply any overlays if you have custom packages
          overlays = [ (import ./modules/overlays.nix) ];

          config.allowUnfree = true;
        };

        # Import common utilities
        lib = import ./lib { inherit pkgs; };

        # Import the common base that all profiles inherit
        commonEnv = import ./modules/common.nix { inherit pkgs; };

        # Helper to build a dev shell from a profile
        mkDevShell = profile:
          let
            profileConfig = import profile { inherit pkgs commonEnv lib; };
          in
          pkgs.mkShell {
            buildInputs = commonEnv.packages ++ profileConfig.packages;
            shellHook = ''
              ${commonEnv.shellHook}
              ${profileConfig.shellHook or ""}
            '';

            # Environment variables
            inherit (profileConfig) env;
          };

      in
      {
        # Main outputs: devShells for each profile
        devShells = {
          # Default shell - maybe a general purpose one
          default = self.devShells.${system}.general;

          # Individual profiles
          bughunting = mkDevShell ./profiles/bughunting.nix;
          python = mkDevShell ./profiles/python.nix;
          rust = mkDevShell ./profiles/rust.nix;
          disassembly = mkDevShell ./profiles/disassembly.nix;
          c-dev = mkDevShell ./profiles/c-dev.nix;
          go-dev = mkDevShell ./profiles/go-dev.nix;

          # General purpose shell
          general = mkDevShell ./profiles/general.nix;
        };

        # You can also expose packages if you build custom tools
        packages = {
          # Example: custom scripts or tools
        };
      }
    );
}
