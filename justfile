deploy:
    nixos-rebuild switch --flake . --use-remote-sudo

substitute:
    nixos-rebuild switch --flake . --use-remote-sudo --option extra-substituters ssh-ng://192.168.1.178

debug:
    nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

build:
    nixos-rebuild build --flake .

build-debug:
    nixos-rebuild build --flake . --show-trace --verbose

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
    deadnix

renew-cert:
    #!/usr/bin/env bash
    read -p "cloudflare token: " -s cf_token
    CF_DNS_API_TOKEN=$cf_token lego --domains="*.licht.moe" --email="lichthagel@tuta.io" --dns cloudflare renew

encrypt-cert:
    #!/usr/bin/env bash
    cd secrets
    cat ../.lego/certificates/_.licht.moe.crt | agenix -e "tls/_.licht.moe.crt" -i ~/.config/sops/age/keys.txt
    cat ../.lego/certificates/_.licht.moe.key | agenix -e "tls/_.licht.moe.key" -i ~/.config/sops/age/keys.txt
