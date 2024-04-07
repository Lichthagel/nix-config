{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.services.flatpak;
in
{
  options.licht.services.flatpak = {
    enable = lib.mkEnableOption "flatpak";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    environment.systemPackages =
      with pkgs;
      (lib.optional config.licht.graphical.plasma5.enable libsForQt5.discover)
      ++ (lib.optional config.licht.graphical.plasma6.enable kdePackages.discover);
  };
}
