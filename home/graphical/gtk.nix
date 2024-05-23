{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.gtk;
in
{
  options.licht.graphical.gtk = {
    enable = lib.mkEnableOption "GTK configuration";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        cursor.enable = false;
        icon.enable = true;
      };
      font = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
    };
  };
}
