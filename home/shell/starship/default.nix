{ config, lib, ... }:
let
  cfg = config.programs.starship.licht;
in
{
  options.programs.starship.licht = {
    enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      catppuccin.enable = false;
    };

    xdg.configFile = {
      "starship.toml".source = ./starship.toml;
    };
  };
}
