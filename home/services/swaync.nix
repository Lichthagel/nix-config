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
          url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/${config.catppuccin.flavor}.css";
          sha256 =
            let
              hashes = {
                frappe = "sha256-/Y0FqRbun2dFnDHTyUvKYTesjH8f2N1n0ITzGR3PlWU=";
                mocha = "sha256-YFboTWj/hiJhmnMbGLtfcxKxvIpJxUCSVl2DgfpglfE=";
              };
            in
            hashes.${config.catppuccin.flavor};
        };

        substitutions = [
          "--replace-warn"
          "Ubuntu Nerd Font"
          "Noto Sans"
        ];
      };
    };

    systemd.user.services.swaync.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, N, exec, ${config.services.swaync.package}/bin/swaync-client -t -sw"
    ];
  };
}
