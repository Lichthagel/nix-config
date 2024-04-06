{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rnote
    zoom-us
  ];

  licht.profiles.graphical = true;
}
