{ config, lib, ... }:
let
  cfg = config.licht.graphical.hypridle;
in
{
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

      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd =
            if config.programs.hyprlock.enable then
              lib.getExe config.programs.hyprlock.package
            else
              (builtins.throw "hyprlock not enabled");
        };

        listener =
          (lib.optional cfg.lock.enable {
            timeout = cfg.lock.timeout;
            on-timeout = "loginctl lock-session";
          })
          ++ (lib.optional cfg.display.enable {
            timeout = cfg.display.timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          })
          ++ (lib.optional cfg.suspend.enable {
            timeout = cfg.suspend.timeout;
            on-timeout = "systemctl suspend";
          });
      };
    };

    systemd.user.services.hypridle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
  };
}
