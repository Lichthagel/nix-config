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
      gitAuthor: "renovate <renovate@example.com>",
      endpoint: "https://${config.networking.hostName}.licht.moe:3456",
      baseDir: "/tmp/renovate/baseDir",
      cacheDir: "/tmp/renovate/cacheDir",
      repositoryCache: "enabled",
      persistRepoData: true,
    };
  '';
in
{
  virtualisation.oci-containers.containers.renovate = {
    image = "ghcr.io/renovatebot/renovate:37-full";
    autoStart = false;
    volumes = [
      "${renovate-config}:/usr/src/app/config.js"
      "renovate-tmp:/tmp/renovate"
    ];
    environment = {
      LOG_LEVEL = "debug";
    };
    environmentFiles = [ config.age.secrets.renovate.path ];
    extraOptions = [ "--network=host" ];
  };

  systemd.services.podman-renovate = {
    requires = [ "forgejo.service" ];
    after = [ "forgejo.service" ];
    serviceConfig = {
      Restart = lib.mkForce "no";
    };
  };

  systemd.timers.podman-renovate = {
    description = "Renovate";
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1h";
      Unit = "podman-renovate.service";
    };
  };

  age.secrets.renovate = {
    file = self + /secrets/renovate;
    owner = "root";
    group = "root";
    mode = "0400";
  };
}
