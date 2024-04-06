{ self, pkgs, ... }:
{
  imports = [ (self + /home) ];

  home.packages = with pkgs; [
    calibre
    anki
    qbittorrent
    libreoffice-qt
  ];
}
