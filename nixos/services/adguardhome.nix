{
  config,
  lib,
  pkgs,
  ...
}:
let
  sources = version: {
    "x86_64-linux" = pkgs.fetchurl {
      url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${version}/AdGuardHome_linux_amd64.tar.gz";
      sha256 = "sha256-vRn5PEeoqJNjnk7ygWHhYXCHZ8iYzBBHH/P++8NaOnY=";
    };
  };

  cfg = config.licht.services.adguardhome;
in
{
  options.licht.services.adguardhome = {
    enable = lib.mkEnableOption "AdGuard Home";

    useUnbound = lib.mkOption {
      type = lib.types.bool;
      default = config.services.unbound.enable;
      description = "Use local Unbound as upstream DNS server";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        adguardhome = prev.adguardhome.overrideAttrs (oldAttrs: rec {
          version = "0.107.44";

          src =
            (sources version).${final.system}
              or (throw "Source for ${final.pname} is not available for ${final.system}");
        });
      })
    ];

    services.adguardhome = {
      enable = true;
      settings = {
        http.address = "127.0.0.1:4567";
        bind_host = "127.0.0.1";
        bind_port = 4567;
        users = [
          {
            name = "licht";
            password = "$2a$10$u8Y3iNYYU0Wg5dlpNOc/9ukr1TYBMeKirSSEI89vUb1uDpLJvgsSa";
          }
        ];
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          protection_enabled = true;
          blocking_mode = "default";
          ratelimit = 0;
          upstream_dns =
            if cfg.useUnbound then
              [
                "127.0.0.1:5353"
                "[::1]:5353"
              ]
            else
              [
                "tls://dns3.digitalcourage.de"
                "tls://fdns1.dismail.de"
                "tls://fdns2.dismail.de"
                "tls://dnsforge.de"
                "https://dnsforge.de/dns-query"
                "quic://dnsforge.de:853"
                "tls://dns.adguard-dns.com"
                "https://dns.adguard-dns.com/dns-query"
                "tls://unfiltered.adguard-dns.com"
                "https://unfiltered.adguard-dns.com/dns-query"
                "tls://adblock.dns.mullvad.net"
                "https://adblock.dns.mullvad.net/dns-query"
                "tls://dns.mullvad.net"
                "https://dns.mullvad.net/dns-query"
              ];
          enable_dnssec = true;
          filtering_enabled = true;
          safe_search.enabled = true;
        };
        filters = [
          {
            enabled = true;
            url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.plus.txt";
            name = "HaGeZi - Multi PRO++";
            id = 1702927019;
          }
        ];
      };
    };

    services.unbound = lib.mkIf cfg.useUnbound {
      settings = {
        server.port = 5353;
      };
      resolveLocalQueries = false;
    };

    networking = {
      resolvconf.useLocalResolver = true;
      networkmanager.dns = "none";
    };
  };
}
