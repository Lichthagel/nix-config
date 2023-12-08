{
  description = "My NixOS configuration";

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-parts,
    flake-utils,
    ...
  } @ inputs: let
    ctp = {
      flavor = "mocha";
      flavorCapitalized = "Mocha";
      accent = "pink";
      accentCapitalized = "Pink";
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      flake = {
        nixosConfigurations = {
          jnbnixos = nixpkgs.lib.nixosSystem {
            system = flake-utils.lib.system.x86_64-linux;

            specialArgs = inputs;

            modules = [
              ./hosts/jnbnixos
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.licht = import ./home;
                home-manager.extraSpecialArgs =
                  inputs
                  // {
                    inherit ctp;
                  };
              }
            ];
          };

          jdnixos = nixpkgs.lib.nixosSystem {
            system = flake-utils.lib.system.x86_64-linux;

            specialArgs = inputs;

            modules = [
              ./hosts/jdnixos
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.licht = import ./home;
                home-manager.extraSpecialArgs =
                  inputs
                  // {
                    inherit ctp;
                  };
              }
            ];
          };
        };
      };

      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        packages = {
          lilex = import ./packages/lilex.nix {inherit pkgs;};
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            just
            nil
            rnix-lsp
            nix-output-monitor
            nvd
          ];
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
