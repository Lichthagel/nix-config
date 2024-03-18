{
  self,
  lib,
  inputs,
  ctp,
  ...
}:
let
  mkArgs = system: {
    inherit self inputs ctp;
    selfPkgs = self.packages.${system};
    unstablePkgs = import inputs.nixpkgs-unstable { inherit system; };
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
