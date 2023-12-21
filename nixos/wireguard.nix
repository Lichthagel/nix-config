{
  config,
  lib,
  ...
}: let
  hostName = config.networking.hostName;

  allowedIPs = ["10.200.200.0/24" "fdc9:281f:4d7:9ee9::/64"];

  hosts = {
    box = {
      ips = ["10.200.200.1/24" "fdc9:281f:4d7:9ee9::1/64"];
    };

    jdnixos = {
      ips = ["10.200.200.2/24" "fdc9:281f:4d7:9ee9::2/64"];
    };

    jnbnixos = {
      ips = ["10.200.200.3/24" "fdc9:281f:4d7:9ee9::3/64"];
    };
  };
in {
  networking.firewall = {
    allowedUDPPorts = [51820];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      inherit (hosts.${config.networking.hostName}) ips;
      privateKeyFile = "/run/secrets/wireguard/private/${hostName}";
      listenPort = 51820;

      peers = [
        {
          inherit allowedIPs;
          presharedKeyFile = "/run/secrets/wireguard/preshared/${hostName}";
          publicKey = "J8RuxFxhXRcQl/FlSzN5ori4KVY7RhHBOx4o4/bmPkc=";
          endpoint = "box.lichthagel.de:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # build extraHosts from hosts binding
  networking.extraHosts = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (
      hostname: hostconfig: (
        builtins.concatStringsSep "\n" (
          lib.forEach hostconfig.ips (ip: "${builtins.head (builtins.split "\/" ip)} ${hostname}.licht")
        )
      )
    )
    hosts
  );
}
