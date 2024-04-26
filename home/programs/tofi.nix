{ config, lib, ... }:
let
  cfg = config.licht.programs.tofi;
in
{
  options.licht.programs.tofi = {
    enable = lib.mkEnableOption "tofi" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      catppuccin.enable = true;
    };
  };
}
