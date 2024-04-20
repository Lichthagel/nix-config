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

    lock = {
      enable = lib.mkEnableOption "lock" // {
        default = true;
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 3 * 60;
        description = "Timeout in seconds before locking the screen";
      };
    };

    display = {
      enable = lib.mkEnableOption "display" // {
        default = true;
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 5 * 60;
        description = "Timeout in seconds before turning off the display";
      };
    };

    suspend = {
      enable = lib.mkEnableOption "suspend" // {
        default = true;
      };

      timeout = lib.mkOption {
        type = lib.types.int;
        default = 10 * 60;
        description = "Timeout in seconds before suspending the system";
      };
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

      listeners =
        (lib.optional cfg.lock.enable {
          timeout = cfg.lock.timeout;
          onTimeout = "loginctl lock-session";
        })
        ++ (lib.optional cfg.display.enable {
          timeout = cfg.display.timeout;
          onTimeout = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        })
        ++ (lib.optional cfg.suspend.enable {
          timeout = cfg.suspend.timeout;
          onTimeout = "systemctl suspend";
        });
    };
  };
}
