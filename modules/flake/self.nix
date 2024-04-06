#
# Provides a `selfPkgs` argument in `perSystem`.
#
# Based on https://github.com/hercules-ci/flake-parts/blob/9126214d0a59633752a136528f5f3b9aa8565b7d/modules/nixpkgs.nix
#
{
  config = {
    perSystem =
      {
        self',
        inputs',
        lib,
        ...
      }:
      {
        config = {
          _module.args.selfPkgs = lib.mkOptionDefault (self'.packages);
        };
      };
  };
}
