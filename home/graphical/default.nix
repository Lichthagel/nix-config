{ pkgs, ... }:
{
  imports = [
    ./gtk.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./kde.nix
    ./qt.nix
    ./waybar
    ./sway.nix
    ./swayidle.nix
  ];

  home.pointerCursor = {
    name = "Vimix-white-cursors";
    size = 32;
    package = pkgs.vimix-cursors;
    gtk.enable = true;
    x11.enable = true;
  };
}
