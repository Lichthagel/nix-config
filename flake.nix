{
  description = "My NixOS configuration";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;

      imports = [
        ./flake/args.nix
        ./flake/packages.nix
        ./flake/dev.nix
        ./flake/nixosConfigurations.nix
      ];

      flake.templates.default = {
        path = ./template;
        description = "My flake template";
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };

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
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?rev=9e781040d9067c2711ec2e9f5b47b76ef70762b3&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces?rev=81adb1c51b2db8a9073dd24f8ac3cb23c9d96dac";
      inputs.hyprland.follows = "hyprland";
    };

    teruko-legacy = {
      url = "github:Lichthagel/teruko-legacy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
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

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
      "https://hyprland.cachix.org"
    ];

    trusted-substituters = [
      "ssh-ng://192.168.1.178"
      "ssh-ng://10.200.200.2"
      "ssh-ng://desktop.licht"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jdnixos:Hij0WitMIbRrp5zUXc70y9VvzIuBroTp1l8hmguEbjQ="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
