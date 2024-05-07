{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.services.swaync;
in
{
  options.licht.services.swaync = {
    enable = lib.mkEnableOption "swaync" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;

      settings = {
        positionX = "center";
        control-center-positionX = "right";
        notification-visibility = {
          spotify = {
            state = "transient";
            app-name = "Spotify";
          };
        };
      };

      style = pkgs.substitute {
        src = pkgs.fetchurl {
          url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/${config.catppuccin.flavour}.css";
          sha256 = "sha256-YFboTWj/hiJhmnMbGLtfcxKxvIpJxUCSVl2DgfpglfE=";
        };

        substitutions = [
          "--replace-warn"
          "Ubuntu Nerd Font"
          "Gabarito"
        ];
      };
    };

    systemd.user.services.swaync.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, N, exec, ${config.services.swaync.package}/bin/swaync-client -t -sw"
    ];
  };
}
