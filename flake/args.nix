{
  perSystem =
    {
      self',
      inputs',
      lib,
      ...
    }:
    {
      _module.args.stablePkgs = lib.mkOptionDefault inputs'.nixpkgs-stable.legacyPackages;
      _module.args.unstablePkgs = lib.mkOptionDefault inputs'.nixpkgs-unstable.legacyPackages;
      _module.args.selfPkgs = lib.mkOptionDefault self'.packages;
    };
}
