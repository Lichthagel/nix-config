{
  self,
  lib,
  inputs,
  ctp,
  ...
}:
let
  mkArgs =
    system:
    let
      ctpBase = ctp;
    in
    {
      inherit self inputs;
      selfPkgs = self.packages.${system};
      unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      ctp = {
        inherit (ctpBase)
          accent
          flavor
          accentCapitalized
          flavorCapitalized
          ;
        palette = lib.importJSON (
          builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/palette/563cdbccc813ae6716ef8242391e6f9dca8d7596/palette.json";
            sha256 = "sha256:1vzg1x2f1j869ggpsjixi4wdw58zxv8641d04vv33ijmdj1d5p8c";
          }
        );
      };
    };
  mkHost =
    {
      hostName,
      system,
      nixosModules,
      homeConfig,
    }:
    lib.nixosSystem {
      inherit system;

      specialArgs = mkArgs system;

      modules = [
        { networking.hostName = hostName; }
        inputs.catppuccin.nixosModules.catppuccin
        {
          catppuccin = {
            # accent = ctp.accent;
            flavour = ctp.flavor;
          };
        }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.licht = homeConfig;
          home-manager.extraSpecialArgs = mkArgs system;
        }
        inputs.sops-nix.nixosModules.sops
      ] ++ nixosModules;
    };
  mkHosts =
    hosts:
    builtins.listToAttrs (
      map (host: {
        name = host.hostName;
        value = mkHost host;
      }) hosts
    );
in
mkHosts [
  {
    hostName = "jdnixos";
    system = "x86_64-linux";

    nixosModules = [ ./jdnixos ];

    homeConfig = ./jdnixos/home.nix;
  }
  {
    hostName = "jnbnixos";
    system = "x86_64-linux";

    nixosModules = [ ./jnbnixos ];

    homeConfig = ./jnbnixos/home.nix;
  }
]
