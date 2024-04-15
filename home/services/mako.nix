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
    };
  };
}
