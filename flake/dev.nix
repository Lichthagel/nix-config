{
  perSystem =
    { pkgs, unstablePkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          unstablePkgs.nixfmt-rfc-style
          just
          nil
          nix-output-monitor
          nvd
          sops
          age
          statix
        ];
      };

      formatter = unstablePkgs.nixfmt-rfc-style;
    };
}
