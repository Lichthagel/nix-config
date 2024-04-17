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
          font = "Cascadia Code:size=11";
        };
      };
    };
  };
}
