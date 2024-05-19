{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.hyprland;
in
{
  options.licht.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
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
        kimageformats
        okular
        polkit-kde-agent
        qt6ct
        qtwayland
      ]);

    programs.hyprland.enable = true;

    services.pipewire.wireplumber.enable = true;

    services.power-profiles-daemon.enable = lib.mkDefault true;

    security.pam.services.hyprlock = { };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
      config = {
        hyprland = {
          default = [
            "hyprland"
            "kde"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };
      };
      configPackages = lib.mkForce [ ];
    };
  };
}
