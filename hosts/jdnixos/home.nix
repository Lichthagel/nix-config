{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    anki
    qbittorrent
    libreoffice-qt
    zoom-us
  ];

  licht.profiles.graphical = true;
}
