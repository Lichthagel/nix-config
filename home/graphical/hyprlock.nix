{
  config,
  osConfig,
  lib,
  ...
}:
let
  cfg = config.licht.graphical.hyprlock;
in
{
  options.licht.graphical.hyprlock = {
    enable = lib.mkEnableOption "hyprlock" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.licht.graphical.hyprland.enable;
        message = "hyprland is required";
      }
      {
        assertion = osConfig.security.pam.services ? hyprlock;
        message = "hyprlock pam service is required";
      }
    ];

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          grace = 5;
        };

        background = [ { path = config.licht.wallpaper; } ];
      };
    };
  };
}
