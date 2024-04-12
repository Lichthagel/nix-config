{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.plasma5;
in
{
  options.licht.graphical.plasma5 = {
    enable = lib.mkEnableOption "KDE Plasma 5";
  };

  config = lib.mkIf cfg.enable {
    # Enable the KDE Plasma Desktop Environment.
    services.xserver.desktopManager.plasma5.enable = true;

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      kate
      khelpcenter
      kwrited
      plasma-browser-integration
    ];

    services.displayManager.defaultSession = "plasmawayland";
  };
}
