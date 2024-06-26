{ self, ... }:
{
  perSystem =
    { pkgs, unstablePkgs, ... }:
    {
      packages = rec {
        afacad = pkgs.callPackage (self + /packages/afacad.nix) { };
        cartograph-cf = pkgs.callPackage (self + /packages/cartograph-cf.nix) { };
        cartograph-cf-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) { font = cartograph-cf; };
        catppuccin-fcitx5 = pkgs.callPackage (self + /packages/catppuccin-fcitx5.nix) { };
        gabarito = pkgs.callPackage (self + /packages/gabarito.nix) { };
        kode-mono-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) {
          font = unstablePkgs.kode-mono;
        };
        lilex = pkgs.callPackage (self + /packages/lilex.nix) { };
        maple-mono-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) { font = pkgs.maple-mono; };
        monolisa = pkgs.callPackage (self + /packages/monolisa.nix) { };
        monolisa-custom = monolisa.overrideAttrs (oldAttrs: {
          pname = "monolisa-custom";

          # enable ss02, ss04, ss08, ss11, ss12, ss13 and set suffix to "Custom"
          src = pkgs.requireFile {
            name = "MonoLisa-Custom-${oldAttrs.version}.zip";
            url = "https://www.monolisa.dev/orders";
            sha256 = "sha256-Odr5Dbxsnp/mobRh7glgs81kMSxRxkFPSGJPZLxitTI=";
          };
        });
        monolisa-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) { font = monolisa; };
        monolisa-custom-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) {
          font = monolisa-custom;
        };
        recursive-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) { font = pkgs.recursive; };
        twilio-sans-mono = pkgs.callPackage (self + /packages/twilio-sans-mono.nix) { };
        twilio-sans-mono-nerdfont = pkgs.callPackage (self + /packages/nerdfont.nix) {
          font = twilio-sans-mono;
        };
      };
    };
}
