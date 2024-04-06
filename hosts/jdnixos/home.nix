{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    anki
    qbittorrent
    libreoffice-qt
  ];

  licht.profiles.graphical = true;
}
