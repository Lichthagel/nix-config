{
  config,
  lib,
  pkgs,
  unstablePkgs,
  self,
  ...
}:
let
  cfg = config.services.forgejo;

  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v0.4.1/catppuccin-gitea.tar.gz";
    sha256 = "sha256-14XqO1ZhhPS7VDBSzqW55kh6n5cFZGZmvRCtMEh8JPI=";
    stripRoot = false;
  };
in
{
  services.forgejo = {
    enable = true;
    package = unstablePkgs.forgejo;
    lfs.enable = true;
    settings = {
      default.APP_NAME = "lichtForge";
      server = rec {
        PROTOCOL = "https";
        DOMAIN = "${config.networking.hostName}.licht.moe";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3456;
        ROOT_URL = "${PROTOCOL}://${config.networking.hostName}.licht.moe:${toString HTTP_PORT}";
        LANDING_PAGE = "login";
        CERT_FILE = config.age.secrets."forgejo/tls/_.licht.moe.crt".path;
        KEY_FILE = config.age.secrets."forgejo/tls/_.licht.moe.key".path;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      ui = {
        DEFAULT_THEME = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}";
        THEMES = builtins.concatStringsSep "," (
          [
            "forgejo-auto"
            "forgejo-light"
            "forgejo-dark"
            "gitea-auto"
            "gitea-light"
            "gitea-dark"
            "forgejo-auto-deuteranopia-protanopia"
            "forgejo-light-deuteranopia-protanopia"
            "forgejo-dark-deuteranopia-protanopia"
            "forgejo-auto-tritanopia"
            "forgejo-light-tritanopia"
            "forgejo-dark-tritanopia"
          ]
          ++ (map (name: lib.removePrefix "theme-" (lib.removeSuffix ".css" name)) (
            builtins.attrNames (builtins.readDir theme)
          ))
        );
      };
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "https://github.com";
      };
      repository = {
        DEFAULT_REPO_UNITS = lib.concatStringsSep "," [ "repo.code" ];
      };
    };
    database = {
      createDatabase = false;
      name = "gitea";
      user = "gitea";
      passwordFile = config.age.secrets."forgejo/db/forge".path;
      type = "postgres";
    };
  };

  systemd.services.forgejo.preStart =
    let
      customDir = cfg.customDir;
      baseDir =
        if lib.versionAtLeast cfg.package.version "1.21.0" then
          "${customDir}/public/assets"
        else
          "${customDir}/public";
    in
    lib.mkAfter ''
      rm -rf ${baseDir}/css
      mkdir -p ${baseDir}
      ln -sf ${theme} ${baseDir}/css
    '';

  services.postgresql = {
    ensureUsers = [
      {
        name = cfg.database.user;
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ cfg.database.name ];
  };

  services.gitea-actions-runner = {
    instances =
      let
        instanceBase = {
          enable = true;
          name = "lichthagel-desktop";
          labels = [
            "ubuntu-latest:docker://gitea/runner-images:ubuntu-latest"
            "ubuntu-22.04:docker://gitea/runner-images:ubuntu-22.04"
            "ubuntu-20.04:docker://gitea/runner-images:ubuntu-20.04"
          ];
          settings = {
            runner = {
              capacity = 5;
            };
            container = {
              network = "bridge";
              options = "--add-host=${config.networking.hostName}.licht.moe:host-gateway";
            };
          };
        };
        mkInstance =
          args:
          lib.mkMerge [
            instanceBase
            (removeAttrs args [ "tokenSecret" ])
            (lib.mkIf (args ? tokenSecret) {
              tokenFile = config.age.secrets."runner_token/${args.tokenSecret}".path;
            })
          ];
      in
      {
        lichtForge = mkInstance {
          url = lib.removeSuffix "/" config.services.forgejo.settings.server.ROOT_URL;
          tokenSecret = "forge";
          settings.cache.port = 11211;
        };
        gitea = mkInstance {
          url = "https://gitea.com";
          tokenSecret = "gitea";
          settings.cache.port = 11212;
        };
        codeberg = mkInstance {
          url = "https://codeberg.org";
          tokenSecret = "codeberg";
          settings.cache.port = 11213;
        };
      };
  };

  # TODO is this always podman0?
  networking.firewall.interfaces.podman0.allowedTCPPorts = [
    11211
    11212
    11213
  ];

  age.secrets =
    let
      mkSecret = secret: {
        file = self + /secrets/${secret};
        owner = cfg.user;
        group = cfg.group;
        mode = "0600";
      };
      mkSecrets =
        secrets:
        lib.mergeAttrsList (
          lib.forEach secrets (secret: {
            "forgejo/${secret}" = mkSecret secret;
          })
        );

      runnerConfig = instance: {
        file = self + /secrets/runner_token/${instance};
        mode = "0444"; # gitea runner module uses dynamic users, so we need to make the token readable by all users :/
      };
    in
    (mkSecrets [
      "db/forge"
      "tls/_.licht.moe.crt"
      "tls/_.licht.moe.key"
    ])
    // lib.mapAttrs' (name: value: lib.nameValuePair "runner_token/${name}" value) (
      lib.genAttrs [
        "forge"
        "gitea"
        "codeberg"
      ] runnerConfig
    );
}
