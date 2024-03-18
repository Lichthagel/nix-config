{ unstablePkgs, ... }:
{
  services.gitea = {
    enable = true;
    package = unstablePkgs.gitea;
    appName = "lichtGitea";
    # repositoryRoot = "/mnt/d/gitea-data/gitea-repositories";
    lfs = {
      enable = true;
      # contentDir = "/mnt/d/gitea-data/lfs";
    };
    settings = {
      # log.ROOT_PATH = "/mnt/d/gitea-data/log";
      server = {
        DOMAIN = "localhost";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3456;
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      ui = {
        # TODO fetch theme from github
        DEFAULT_THEME = "catppuccin-mocha-green";
        THEMES = "auto,gitea,arc-green,catppuccin-latte-rosewater,catppuccin-latte-flamingo,catppuccin-latte-pink,catppuccin-latte-mauve,catppuccin-latte-red,catppuccin-latte-maroon,catppuccin-latte-peach,catppuccin-latte-yellow,catppuccin-latte-green,catppuccin-latte-teal,catppuccin-latte-sky,catppuccin-latte-sapphire,catppuccin-latte-blue,catppuccin-latte-lavender,catppuccin-frappe-rosewater,catppuccin-frappe-flamingo,catppuccin-frappe-pink,catppuccin-frappe-mauve,catppuccin-frappe-red,catppuccin-frappe-maroon,catppuccin-frappe-peach,catppuccin-frappe-yellow,catppuccin-frappe-green,catppuccin-frappe-teal,catppuccin-frappe-sky,catppuccin-frappe-sapphire,catppuccin-frappe-blue,catppuccin-frappe-lavender,catppuccin-macchiato-rosewater,catppuccin-macchiato-flamingo,catppuccin-macchiato-pink,catppuccin-macchiato-mauve,catppuccin-macchiato-red,catppuccin-macchiato-maroon,catppuccin-macchiato-peach,catppuccin-macchiato-yellow,catppuccin-macchiato-green,catppuccin-macchiato-teal,catppuccin-macchiato-sky,catppuccin-macchiato-sapphire,catppuccin-macchiato-blue,catppuccin-macchiato-lavender,catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender";
      };
    };
    database = {
      createDatabase = false;
      password = "4321";
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
}
