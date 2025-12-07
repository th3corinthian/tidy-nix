{ pkgs }:

rec {
  # Helper to merge multiple profile configurations
  mergeProfiles = profiles:
    let
      allPackages = builtins.concatLists (map (p: p.packages) profiles);
      allShellHooks = builtins.concatStringsSep "\n" (map (p: p.shellHook or "") profiles);
      allEnvs = builtins.foldl' (acc: p: acc // (p.env or {})) {} profiles;
    in {
      packages = allPackages;
      shellHook = allShellHooks;
      env = allEnvs;
    };

  # Helper to create a minimal profile
  mkMinimalProfile = { packages ? [], shellHook ? "", env ? {} }: {
    inherit packages shellHook env;
  };

  # Conditional package inclusion based on system
  conditionalPackage = system: pkg:
    if pkgs.stdenv.isLinux then pkg
    else if pkgs.stdenv.isDarwin then null
    else null;
}
