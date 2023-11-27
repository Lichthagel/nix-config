deploy:
    nixos-rebuild switch --flake . --use-remote-sudo

debug:
    nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

update:
    nix flake update

history:
    nix profile history --profile /nix/var/nix/profiles/system

gc:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
    sudo nix store gc --debug
