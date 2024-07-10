{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.swayidle.licht;

  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
  swaylock = lib.getExe pkgs.swaylock;
  systemctl = lib.getExe' pkgs.systemd "systemctl";
in
{
  options.services.swayidle.licht = {
    enable = lib.mkEnableOption "swayidle" // {
      default = config.wayland.windowManager.sway.enable;
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

  config.services.swayidle = lib.mkIf cfg.enable {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${swaylock} -f; ${swaymsg} 'output * power on'";
      }
      {
        event = "after-resume";
        command = "${swaymsg} 'output * power on'";
      }
    ];

    timeouts = lib.mkMerge [
      (lib.mkIf cfg.lock.enable [
        {
          timeout = cfg.lock.timeout;
          command = "${swaylock} -f";
        }
      ])
      (lib.mkIf cfg.display.enable [
        {
          timeout = cfg.display.timeout;
          command = "${swaymsg} 'output * power off'";
          resumeCommand = "${swaymsg} 'output * power on'";
        }
      ])
      (lib.mkIf cfg.suspend.enable [
        {
          timeout = cfg.suspend.timeout;
          command = "${systemctl} suspend";
        }
      ])
    ];
  };
}
