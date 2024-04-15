{ config, lib, ... }:
let
  cfg = config.licht.programs.mako;
in
{
  options.licht.programs.mako = {
    enable = lib.mkEnableOption "mako" // { default = config.licht.graphical.hyprland.enable; };
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      catppuccin.enable = true;

      anchor = "top-center";
      font = "Gabarito 10";
      width = 500;
      height = 100;
      borderRadius = 10;
      defaultTimeout = 10000;
    };
  };
}
