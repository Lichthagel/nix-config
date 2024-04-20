{
  lib,
  pkgs,
  stablePkgs,
  ...
}:
{
  imports = [ ./teruko.nix ];

  home.packages = with pkgs; [
    (calibre.override {
      python3Packages = pkgs.python3Packages // {
        mechanize = stablePkgs.python3Packages.mechanize;
      };
    })
    anki
    qbittorrent
    libreoffice-qt
    zoom-us
    rclone
  ];

  licht.unfreePackages = map lib.getName [ pkgs.zoom-us ];

  licht.profiles.graphical = true;
  licht.graphical.hyprland.perMonitorWorkspaces = true;

  wayland.windowManager.hyprland.settings = {
    env = [ "WLR_NO_HARDWARE_CURSORS,1" ];
    monitor = [
      "DP-2,3440x1440@144,1920x0,1"
      "DP-3,1920x1080@60,0x180,1"
    ];
  };

  services.mako.output = "DP-2";
}
