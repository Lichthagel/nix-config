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
}
