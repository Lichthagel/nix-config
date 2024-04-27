{ config, lib, ... }:
let
  cfg = config.licht.services.mako;
in
{
  options.licht.services.mako = {
    enable = lib.mkEnableOption "mako";
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
