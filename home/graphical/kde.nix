{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.kde;
in
{
  options.licht.graphical.kde = {
    enable = lib.mkEnableOption "KDE Plasma configuration" // {
      default = osConfig.licht.graphical.plasma5.enable || osConfig.licht.graphical.plasma6.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.catppuccin-kde.override {
        flavour = [ config.catppuccin.flavor ];
        accents = [ config.catppuccin.accent ];
        winDecStyles = [ "classic" ];
      })
      (pkgs.catppuccin-papirus-folders.override { inherit (config.catppuccin) flavor accent; })
    ];
  };
}
