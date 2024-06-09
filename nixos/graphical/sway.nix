{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.sway.licht;
in
{
  options.programs.sway.licht = {
    enable = lib.mkEnableOption "sway";
  };

  config = lib.mkIf cfg.enable {
    # TODO just copied from hyprland
    environment.systemPackages =
      with pkgs;
      [
        kitty
        libsForQt5.qt5ct
        networkmanagerapplet
      ]
      ++ (with kdePackages; [
        ark
        dolphin
        dolphin-plugins
        ffmpegthumbs
        gwenview
        kdegraphics-thumbnailers
        kfilemetadata
        kimageformats
        kio
        kio-admin
        kio-extras
        kio-fuse
        kservice
        libheif
        okular
        polkit-kde-agent
        plasma-workspace
        qt6ct
        qtimageformats
        qtwayland
      ]);

    programs.sway.enable = true;

    xdg.portal.wlr.enable = lib.mkForce true;
  };
}
