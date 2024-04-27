{ config, lib, ... }:
let
  cfg = config.licht.graphical.waybar;
in
{
  options.licht.graphical.waybar = {
    enable = lib.mkEnableOption "waybar" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      catppuccin = {
        enable = true;
        mode = "createLink";
      };
      systemd.enable = true;
      settings = import ./settings.nix { inherit lib; };
      style = ./style.css;
    };

    # only launch in specific sessions
    systemd.user.services.waybar = {
      Install.WantedBy = lib.mkForce (
        lib.optional config.licht.graphical.hyprland.enable "hyprland-session.target"
      );

      Unit.Before = lib.mkIf config.licht.autostart.systemd [ "autostart.target" ];
    };
  };
}
