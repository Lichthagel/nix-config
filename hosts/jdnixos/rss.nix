{ config, self, ... }:
let
  cfg = config.services.freshrss;
in
{
  services.freshrss = {
    enable = true;
    language = "de";
    defaultUser = "licht";
    passwordFile = config.age.secrets."freshrss/password".path;
    baseUrl = "https://jdnixos.licht.moe:7899";
    database = {
      type = "pgsql";
      host = "127.0.0.1";
      port = config.services.postgresql.settings.port;
      name = "freshrss";
      user = "freshrss";
      passFile = config.age.secrets."freshrss/db".path;
    };
  };

  services.nginx.virtualHosts.${cfg.virtualHost} = {
    sslCertificate = config.age.secrets."freshrss/tls_crt".path;
    sslCertificateKey = config.age.secrets."freshrss/tls_key".path;

    forceSSL = true;
    enableACME = false;

    listen = [
      {
        addr = "0.0.0.0";
        port = 7899;
        ssl = true;
      }
    ];
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = cfg.database.user;
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ cfg.database.name ];
  };

  age.secrets = {
    "freshrss/password" = {
      file = self + /secrets/password/freshrss;
      owner = cfg.user;
      group = cfg.user;
      mode = "0600";
    };
    "freshrss/db" = {
      file = self + /secrets/db/freshrss;
      owner = cfg.user;
      group = cfg.user;
      mode = "0600";
    };
    "freshrss/tls_crt" = {
      file = self + /secrets/tls/_.licht.moe.crt;
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
      mode = "0600";
    };
    "freshrss/tls_key" = {
      file = self + /secrets/tls/_.licht.moe.key;
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
      mode = "0600";
    };
  };
}
