{
  config,
  lib,
  pkgs,
  selfPkgs,
  ctp,
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
      catppuccin.enable = true;
      cursorTheme = {
        name = "Vimix-white-cursors";
        package = pkgs.vimix-cursors;
      };
      font = {
        name = "Gabarito";
        package = selfPkgs.gabarito;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          inherit (ctp) flavor accent;
        };
      };
    };
  };
}
