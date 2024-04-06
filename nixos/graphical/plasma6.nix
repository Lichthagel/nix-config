{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.plasma6;
in
{
  options = {
    licht.graphical.plasma6 = {
      enable = lib.mkEnableOption "KDE Plasma 6";
    };
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      khelpcenter
      kwrited
      plasma-browser-integration
    ];
  };
}
