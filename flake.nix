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
    ({withSystem, ...}: {
      imports = [
        {config._module.args._inputs = inputs // {inherit self;};}
      ];

      flake = {
        homeModules = {
          full = ./home;
        };

        nixosConfigurations = import ./hosts {
          inherit inputs self ctp;
          inherit (nixpkgs) lib;
        };
      };

      systems = flake-utils.lib.defaultSystems;

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        packages = rec {
          afacad = pkgs.callPackage ./packages/afacad.nix {};
          catppuccin-fcitx5 = pkgs.callPackage ./packages/catppuccin-fcitx5.nix {};
          catppuccin-sddm = pkgs.callPackage ./packages/catppuccin-sddm.nix {};
          gabarito = pkgs.callPackage ./packages/gabarito.nix {};
          lilex = pkgs.callPackage ./packages/lilex.nix {};
          monolisa = pkgs.callPackage ./packages/monolisa.nix {};
          monolisa-custom = monolisa.overrideAttrs (oldAttrs: {
            pname = "monolisa-custom";

            # enable ss02, ss04, ss08, ss11, ss12 and set suffix to "Custom"
            src = pkgs.requireFile {
              name = "MonoLisa-Custom-${oldAttrs.version}.zip";
              url = "https://www.monolisa.dev/orders";
              sha256 = "sha256:0ilvvzg709l60l1cwdih729n71kdl83waaa23as94mnzln99z1rf";
            };
          });
          monolisa-nerdfont = pkgs.callPackage ./packages/nerdfont.nix {font = monolisa;};
          monolisa-custom-nerdfont = pkgs.callPackage ./packages/nerdfont.nix {font = monolisa-custom;};
          recursive-nerdfont = pkgs.callPackage ./packages/nerdfont.nix {font = pkgs.recursive;};
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            just
            nil
            rnix-lsp
            nix-output-monitor
            nvd
            sops
            age
          ];
        };

        formatter = pkgs.alejandra;
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];

    auto-optimise-store = true;

    substituters = [
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];

    trusted-substituters = [
      "ssh-ng://192.168.1.178"
      "ssh-ng://10.200.200.2"
      "ssh-ng://desktop.licht"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "jdnixos:Hij0WitMIbRrp5zUXc70y9VvzIuBroTp1l8hmguEbjQ="
    ];
  };
}
