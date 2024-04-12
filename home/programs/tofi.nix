{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.programs.tofi;
in
{
  options.licht.programs.tofi = {
    enable = lib.mkEnableOption "tofi" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ tofi ]; };
}
