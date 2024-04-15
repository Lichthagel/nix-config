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
    };
  };
}
