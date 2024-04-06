{ config, lib, ... }:
let
  cfg = config.licht.wireguard;
in
{
  options.licht.wireguard = {
    enable = lib.mkEnableOption "Wireguard";
  };

  config = lib.mkIf cfg.enable (
    let
      hostName = config.networking.hostName;

      allowedIPs = [
        "10.200.200.0/24"
        "fdc9:281f:4d7:9ee9::/64"
      ];

      hosts = {
        box = {
          ips = [
            "10.200.200.1/24"
            "fdc9:281f:4d7:9ee9::1/64"
          ];
        };

        jdnixos = {
          ips = [
            "10.200.200.2/24"
            "fdc9:281f:4d7:9ee9::2/64"
          ];
        };

        jnbnixos = {
          ips = [
            "10.200.200.3/24"
            "fdc9:281f:4d7:9ee9::3/64"
          ];
        };
      };
    in
    {
      networking.firewall = {
        allowedUDPPorts = [ 51820 ];
      };

      networking.networkmanager.ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wireguard/${hostName}.env".path ];

        profiles = {
          "wg0" = {
            connection = {
              id = "wg0";
              type = "wireguard";
              interface-name = "wg0";
            };
            wireguard = {
              listen-port = 51820;
              private-key = "$PRIVATE_KEY";
            };
            "wireguard-peer.J8RuxFxhXRcQl/FlSzN5ori4KVY7RhHBOx4o4/bmPkc=" = {
              endpoint = "box.lichthagel.de:51820";
              preshared-key = "$PRESHARED_KEY";
              preshared-key-flags = 0;
              persistent-keepalive = 25;
              allowed-ips = builtins.concatStringsSep ";" allowedIPs;
            };
            ipv4 = {
              address1 = builtins.elemAt hosts.${config.networking.hostName}.ips 0;
              method = "manual";
            };
            ipv6 = {
              addr-gen-mode = "default";
              address1 = builtins.elemAt hosts.${config.networking.hostName}.ips 1;
              method = "manual";
            };
          };
        };
      };

      # build extraHosts from hosts binding
      networking.extraHosts = builtins.concatStringsSep "\n" (
        lib.mapAttrsToList (
          hostname: hostconfig:
          (builtins.concatStringsSep "\n" (
            lib.forEach hostconfig.ips (ip: "${builtins.head (builtins.split "\/" ip)} ${hostname}.licht")
          ))
        ) hosts
      );
    }
  );
}
