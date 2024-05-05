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
    home.packages = with pkgs; [ swaynotificationcenter ];

    xdg.configFile =
      let
        serviceFile = "${pkgs.swaynotificationcenter}/share/systemd/user/swaync.service";
      in
      {
        # enable swaync user service
        "systemd/user/swaync.service".source = serviceFile;
        "systemd/user/hyprland-session.target.wants/swaync.service" =
          lib.mkIf config.licht.graphical.hyprland.enable
            { source = serviceFile; };

        # swaync config
        "swaync/config.json".text = builtins.toJSON {
          "positionX" = "center";
          "notification-visibility" = {
            "spotify" = {
              "state" = "transient";
              "app-name" = "Spotify";
            };
          };
        };
      };

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
    ];
  };
}
