{
  config,
  lib,
  unstablePkgs,
  self,
  ...
}:
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
        CERT_FILE = config.age.secrets."tls/_.licht.moe.crt".path;
        KEY_FILE = config.age.secrets."tls/_.licht.moe.key".path;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      ui = {
        # TODO fetch theme from github
        DEFAULT_THEME = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}";
        THEMES = "auto,gitea,arc-green,catppuccin-latte-rosewater,catppuccin-latte-flamingo,catppuccin-latte-pink,catppuccin-latte-mauve,catppuccin-latte-red,catppuccin-latte-maroon,catppuccin-latte-peach,catppuccin-latte-yellow,catppuccin-latte-green,catppuccin-latte-teal,catppuccin-latte-sky,catppuccin-latte-sapphire,catppuccin-latte-blue,catppuccin-latte-lavender,catppuccin-frappe-rosewater,catppuccin-frappe-flamingo,catppuccin-frappe-pink,catppuccin-frappe-mauve,catppuccin-frappe-red,catppuccin-frappe-maroon,catppuccin-frappe-peach,catppuccin-frappe-yellow,catppuccin-frappe-green,catppuccin-frappe-teal,catppuccin-frappe-sky,catppuccin-frappe-sapphire,catppuccin-frappe-blue,catppuccin-frappe-lavender,catppuccin-macchiato-rosewater,catppuccin-macchiato-flamingo,catppuccin-macchiato-pink,catppuccin-macchiato-mauve,catppuccin-macchiato-red,catppuccin-macchiato-maroon,catppuccin-macchiato-peach,catppuccin-macchiato-yellow,catppuccin-macchiato-green,catppuccin-macchiato-teal,catppuccin-macchiato-sky,catppuccin-macchiato-sapphire,catppuccin-macchiato-blue,catppuccin-macchiato-lavender,catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender";
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
      passwordFile = config.age.secrets.forge_db.path;
      type = "postgres";
    };
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "gitea";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "gitea" ];
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
        };
        gitea = mkInstance {
          url = "https://gitea.com";
          tokenSecret = "gitea";
        };
        codeberg = mkInstance {
          url = "https://codeberg.org";
          tokenSecret = "codeberg";
        };
      };
  };

  age.secrets =
    let
      runnerConfig = instance: {
        file = self + /secrets/runner_token/${instance};
        mode = "0444"; # gitea runner module uses dynamic users, so we need to make the token readable by all users :/
      };
    in
    {
      forge_db = {
        file = self + /secrets/forge_db;
        owner = config.services.forgejo.user;
        group = config.services.forgejo.group;
        mode = "0600";
      };

      "tls/_.licht.moe.crt" = {
        file = self + /secrets/tls/_.licht.moe.crt;
        owner = config.services.forgejo.user;
        group = config.services.forgejo.group;
        mode = "0600";
      };

      "tls/_.licht.moe.key" = {
        file = self + /secrets/tls/_.licht.moe.key;
        owner = config.services.forgejo.user;
        group = config.services.forgejo.group;
        mode = "0600";
      };
    }
    // lib.mapAttrs' (name: value: lib.nameValuePair "runner_token/${name}" value) (
      lib.genAttrs [
        "forge"
        "gitea"
        "codeberg"
      ] runnerConfig
    );
}
