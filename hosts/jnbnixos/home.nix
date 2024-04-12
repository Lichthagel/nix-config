{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rnote
    zoom-us
    rclone
  ];

  licht.profiles.graphical = true;
}
