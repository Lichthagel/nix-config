let
  licht = "age1gl5f2yuaqpq0a78zel22ql9fgulrssk959sp6pwa4qfm9guvpqrq9spmk8";

  jdnixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeVbEVHuH71i1gxMD6WbWoVbbnPuM8lHWXBRpMJ3nKY";
  jnbnixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoluPSu7NEMZ9Ekes59n+C+UdWfcXlVeqgnzDwVwhOz";
in
{
  "wireguard/jdnixos.env".publicKeys = [
    licht
    jdnixos
  ];
  "wireguard/jnbnixos.env".publicKeys = [
    licht
    jnbnixos
  ];

  "ssh/id_ed25519_shared".publicKeys = [
    licht
  ];

  "nix_cache/jdnixos/private".publicKeys = [
    licht
    jdnixos
  ];

  "forge_db".publicKeys = [
    licht
    jdnixos
  ];

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
}
