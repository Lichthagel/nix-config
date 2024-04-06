{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    anki
    qbittorrent
    libreoffice-qt
  ];
}
