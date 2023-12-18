{
  services.adguardhome = {
    enable = true;
    settings = {
      bind_port = 4567;
      users = [
        {
          name = "licht";
          password = "$2a$10$u8Y3iNYYU0Wg5dlpNOc/9ukr1TYBMeKirSSEI89vUb1uDpLJvgsSa";
        }
      ];
      dns = {
        protection_enabled = true;
        blocking_mode = "default";
        ratelimit = 0;
        upstream_dns = [
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

  networking = {
    resolvconf.useLocalResolver = true;
    networkmanager.dns = "none";
  };
}
