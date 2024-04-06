{ pkgs, ... }:
{
  home.packages = with pkgs; [ rnote ];

  licht.profiles.graphical = true;
}
