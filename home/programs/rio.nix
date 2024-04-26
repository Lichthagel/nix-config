{ config, lib, ... }:
let
  cfg = config.licht.programs.rio;
in
{
  options.licht.programs.rio = {
    enable = lib.mkEnableOption "rio" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rio = {
      enable = true;
    };
  };
}
