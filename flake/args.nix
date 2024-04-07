{
  perSystem =
    {
      self',
      inputs',
      lib,
      ...
    }:
    {
      _module.args.unstablePkgs = lib.mkOptionDefault inputs'.nixpkgs-unstable.legacyPackages;
      _module.args.selfPkgs = lib.mkOptionDefault self'.packages;
    };
}
