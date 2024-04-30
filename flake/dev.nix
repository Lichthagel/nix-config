{
  perSystem =
    { pkgs, unstablePkgs, inputs', ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          unstablePkgs.nixfmt-rfc-style
          just
          nil
          nixd
          nix-output-monitor
          nvd
          statix
          deadnix
          inputs'.ragenix.packages.default
        ];
      };

      formatter = unstablePkgs.nixfmt-rfc-style;
    };
}
