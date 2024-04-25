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
      systemd.enable = true;
    };

    # only launch in specific sessions
    systemd.user.services.waybar.Install.WantedBy = lib.mkForce (
      (lib.optional config.licht.graphical.hyprland.enable "hyprland-session.target")
    );
  };
}
