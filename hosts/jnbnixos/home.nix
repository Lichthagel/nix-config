{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    rnote
    zoom-us
    rclone
  ];

  licht.unfreePackages = map lib.getName [ pkgs.zoom-us ];

  licht.profiles.graphical = true;

  wayland.windowManager.hyprland.settings.monitor = [ ",1920x1080,auto,1" ];
}
