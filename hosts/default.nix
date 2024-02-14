{
  self,
  lib,
  inputs,
  ctp,
  ...
}: {
  jdnixos = lib.nixosSystem rec {
    system = inputs.flake-utils.lib.system.x86_64-linux;

    specialArgs =
      inputs
      // {
        selfPkgs = self.packages.${system};
        unstablePkgs = import inputs.nixpkgs-unstable {
          inherit system;
        };
      };

    modules = [
      ./jdnixos
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.licht = ./jdnixos/home.nix;
        home-manager.extraSpecialArgs =
          inputs
          // {
            inherit ctp;
            selfPkgs = self.packages.${system};
            unstablePkgs = import inputs.nixpkgs-unstable {
              inherit system;
            };
          };
      }
      inputs.sops-nix.nixosModules.sops
    ];
  };

  jnbnixos = lib.nixosSystem rec {
    system = inputs.flake-utils.lib.system.x86_64-linux;

    specialArgs =
      inputs
      // {
        selfPkgs = self.packages.${system};
        unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      };

    modules = [
      ./jnbnixos
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.licht = ./jnbnixos/home.nix;
        home-manager.extraSpecialArgs =
          inputs
          // {
            inherit ctp;
            selfPkgs = self.packages.${system};
            unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
          };
      }
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
