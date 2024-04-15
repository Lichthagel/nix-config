{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    anki
    qbittorrent
    libreoffice-qt
    zoom-us
    rclone
  ];

  licht.profiles.graphical = true;

  wayland.windowManager.hyprland.settings = {
    env = [ "WLR_NO_HARDWARE_CURSORS,1" ];
    monitor = [ "DP-2,3440x1440@144,1920x0,1" "DP-3,1920x1080@60,0x0,1" ];
  };
}
