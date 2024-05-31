{
  self,
  inputs,
  withSystem,
  lib,
  ...
}:
{
  flake = {
    nixosConfigurations =
      let
        ctpBase = (builtins.fromTOML (builtins.readFile (self + /config.toml))).catppuccin;
        mkArgs =
          system:
          withSystem system (systemArgs: {
            inherit self inputs;

            inherit (systemArgs)
              self'
              inputs'
              selfPkgs
              stablePkgs
              unstablePkgs
              ;
          });
        mkHost =
          { hostName, system }:
          lib.nixosSystem {
            inherit system;

            specialArgs = mkArgs system;

            modules = [
              inputs.home-manager.nixosModules.home-manager
              inputs.catppuccin.nixosModules.catppuccin
              inputs.agenix.nixosModules.default
              {
                networking.hostName = hostName;
                catppuccin = {
                  enable = true;
                  inherit (ctpBase) accent flavor;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.licht = {
                  imports = [
                    (self + /common)
                    (self + /home)
                    (self + /hosts/${hostName}/home.nix)
                  ];
                };
                home-manager.extraSpecialArgs = mkArgs system;
                home-manager.backupFileExtension = "backup";
              }
              (self + /common)
              (self + /nixos)
              (self + /hosts/${hostName})
            ];
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
        }
        {
          hostName = "jnbnixos";
          system = "x86_64-linux";
        }
      ];
  };
}
