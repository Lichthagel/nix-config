#
# Provides a `unstablePkgs` argument in `perSystem`.
#
# Based on https://github.com/hercules-ci/flake-parts/blob/9126214d0a59633752a136528f5f3b9aa8565b7d/modules/nixpkgs.nix
#
{
  config = {
    perSystem =
      { inputs', lib, ... }:
      {
        config = {
          _module.args.unstablePkgs = lib.mkOptionDefault (
            builtins.seq (inputs'.nixpkgs-unstable
              or (throw "flake: The flake does not have a `nixpkgs-unstable` input. Please add it, or set `perSystem._module.args.unstablePkgs` yourself.")
            ) inputs'.nixpkgs-unstable.legacyPackages
          );
        };
      };
  };
}
