{
  config,
  lib,
  pkgs,
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
      theme = {
        name = "Catppuccin-${ctp.flavorCapitalized}-Standard-${ctp.accentCapitalized}-Dark";
        package = pkgs.catppuccin-gtk.override {
          variant = ctp.flavor;
          accents = [ ctp.accent ];
        };
      };
      cursorTheme = {
        name = "Vimix-white-cursors";
        package = pkgs.vimix-cursors;
      };
      font = {
        name = "Outfit";
        package = pkgs.google-fonts.override { fonts = [ "Outfit" ]; };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = ctp.flavor;
          accent = ctp.accent;
        };
      };
    };
  };
}
