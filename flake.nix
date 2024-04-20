{
  description = "My NixOS configuration";

  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {

        imports = [
          ./flake/args.nix
          ./flake/packages.nix
          ./flake/dev.nix
          ./flake/nixosConfigurations.nix
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
      }
    );

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      url = "http://rime.cx/v1/github/hyprwm/Hyprland.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "http://rime.cx/v1/github/hyprwm/hypridle.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    hyprlock = {
      url = "http://rime.cx/v1/github/hyprwm/hyprlock.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=f7a306396da163422048fd38eecd92c68ce21e58";
      inputs.hyprland.follows = "hyprland";
    };

    teruko-legacy = {
      url = "github:Lichthagel/teruko-legacy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;

    trusted-users = [
      "root"
      "@wheel"
    ];

    substituters = [ "https://cache.nixos.org/" ];

    extra-substituters = [ "https://nix-community.cachix.org" ];

    trusted-substituters = [
      "ssh-ng://192.168.1.178"
      "ssh-ng://10.200.200.2"
      "ssh-ng://desktop.licht"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jdnixos:Hij0WitMIbRrp5zUXc70y9VvzIuBroTp1l8hmguEbjQ="
    ];
  };
}
