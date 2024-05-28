{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  renovate-config = pkgs.writeText "renovate-config.js" ''
    module.exports = {
      platform: "gitea",
      onboardingConfig: {
        extends: ["config:recommended"],
      },
      autodiscover: true,
      gitAuthor: "Renovate <renovate@renovate.invalid>",
      endpoint: "https://${config.networking.hostName}.licht.moe:3456",
      baseDir: "/tmp/renovate/baseDir",
      cacheDir: "/tmp/renovate/cacheDir",
      repositoryCache: "enabled",
      persistRepoData: true,
    };
  '';

  hosts = pkgs.writeText "hosts" ''
    10.0.2.2 ${config.networking.hostName}.licht.moe
  '';

  backend = config.virtualisation.oci-containers.backend;
in
{
  virtualisation.oci-containers.containers.renovate = {
    image = "ghcr.io/renovatebot/renovate:37-full";
    autoStart = false;
    volumes = [
      "${renovate-config}:/usr/src/app/config.js"
      "renovate-tmp:/tmp/renovate"
      "${hosts}:/etc/hosts"
    ];
    environment = {
      LOG_LEVEL = "info";
    };
    environmentFiles = [ config.age.secrets.renovate.path ];
    extraOptions = [ "--network=slirp4netns:allow_host_loopback=true" ];
  };

  systemd.services."${backend}-renovate" = {
    requires = [ "forgejo.service" ];
    after = [ "forgejo.service" ];
    serviceConfig = {
      Restart = lib.mkForce "no";
    };
  };

  systemd.timers."${backend}-renovate" = {
    description = "Renovate";
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1h";
      Unit = "${backend}-renovate.service";
    };
  };

  age.secrets.renovate = {
    file = self + /secrets/renovate;
    owner = "root";
    group = "root";
    mode = "0400";
  };
}
