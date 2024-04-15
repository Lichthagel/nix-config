{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rnote
    zoom-us
    rclone
  ];

  licht.profiles.graphical = true;
  
  wayland.windowManager.hyprland.settings.monitor = [ ",1920x1080,auto,1" ];
}
