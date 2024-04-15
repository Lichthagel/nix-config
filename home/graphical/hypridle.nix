{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.licht.graphical.hypridle;
in
{
  imports = [ inputs.hypridle.homeManagerModules.default ];

  options.licht.graphical.hypridle = {
    enable = lib.mkEnableOption "hypridle" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.wayland.windowManager.hyprland.enable;
        message = "hyprland is required";
      }
    ];

    services.hypridle = {
      enable = true;

      package = pkgs.hypridle; # use nixpkgs

      lockCmd =
        if config.programs.hyprlock.enable then
          lib.getExe config.programs.hyprlock.package
        else
          (builtins.throw "hyprlock not enabled");
      beforeSleepCmd = "loginctl lock-session";
      afterSleepCmd = "hyprctl dispatch dpms on";

      listeners = [
        {
          timeout = 180;
          onTimeout = "loginctl lock-session";
        }
        {
          timeout = 300;
          onTimeout = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          onTimeout = "systemctl suspend";
        }
      ];
    };
  };
}
