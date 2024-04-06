{
  config,
  osConfig,
  lib,
  pkgs,
  ctp,
  ...
}:
let
  cfg = config.licht.graphical.kde;
in
{
  options.licht.graphical.kde = {
    enable = lib.mkEnableOption "KDE Plasma configuration" // {
      default = osConfig.licht.graphical.plasma5.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.catppuccin-kde.override {
        flavour = [ ctp.flavor ];
        accents = [ ctp.accent ];
        winDecStyles = [ "classic" ];
      })
      (pkgs.catppuccin-papirus-folders.override { inherit (ctp) flavor accent; })
      pkgs.capitaine-cursors
      pkgs.vimix-cursors
      (pkgs.catppuccin-gtk.override {
        variant = ctp.flavor;
        accents = [ ctp.accent ];
      })
    ];

    home.pointerCursor = {
      name = "Vimix Cursors - White";
      # size = 32;
      package = pkgs.vimix-cursors;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
