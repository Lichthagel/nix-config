let
  licht = "age1gl5f2yuaqpq0a78zel22ql9fgulrssk959sp6pwa4qfm9guvpqrq9spmk8";

  jdnixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeVbEVHuH71i1gxMD6WbWoVbbnPuM8lHWXBRpMJ3nKY";
  jnbnixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoluPSu7NEMZ9Ekes59n+C+UdWfcXlVeqgnzDwVwhOz";
in
{
  # WIREGUARD
  "wireguard/jdnixos.env".publicKeys = [
    licht
    jdnixos
  ];
  "wireguard/jnbnixos.env".publicKeys = [
    licht
    jnbnixos
  ];

  # SSH
  "ssh/id_ed25519_shared".publicKeys = [ licht ];

  # NIXOS
  "nix_cache/jdnixos/private".publicKeys = [
    licht
    jdnixos
  ];

  # DATABASE
  "forge_db".publicKeys = [
    licht
    jdnixos
  ];

  # RUNNER TOKENS
  "runner_token/forge".publicKeys = [
    licht
    jdnixos
  ];
  "runner_token/gitea".publicKeys = [
    licht
    jdnixos
  ];
  "runner_token/codeberg".publicKeys = [
    licht
    jdnixos
  ];

  # TLS
  "tls/_.licht.moe.crt".publicKeys = [
    licht
    jdnixos
  ];
  "tls/_.licht.moe.key".publicKeys = [
    licht
    jdnixos
  ];
}
