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
    rec {
      inherit self inputs;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      selfPkgs = self.packages.${system};
      unstablePkgs = import inputs.nixpkgs-unstable { inherit system; };
      ctp = {
        inherit (ctpBase)
          accent
          flavor
          accentCapitalized
          flavorCapitalized
          ;
        palette = lib.importJSON "${
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "palette";
            rev = "e44233ceae6809d50cba3c0c95332cc87ffff022";
            sha256 = "sha256-96ZO0LBN9z0+sIg3mdFI6kNSgX3R2x3bND9KzyYpFy4=";
          }
        }/palette.json";
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
