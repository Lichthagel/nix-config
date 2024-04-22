deploy:
    nh os switch .

substitute:
    nixos-rebuild switch --flake . --use-remote-sudo --option extra-substituters ssh-ng://192.168.1.178

debug:
    nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

update:
    nix flake update

history:
    nix profile history --profile /nix/var/nix/profiles/system

gc:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
    sudo nix store gc --debug

format:
    nixfmt ./**/*.nix

lint:
    statix check .