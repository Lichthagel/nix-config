{ config, lib, ... }:
let
  cfg = config.licht.programs.foot;
in
{
  options.licht.programs.foot = {
    enable = lib.mkEnableOption "foot" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        main = {
          font = "CaskaydiaCove Nerd Font:size=11";
        };
        colors = {
          alpha = 0.8;
        };
      };
    };
  };
}
