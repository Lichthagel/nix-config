{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.hyprland;
in
{
  options.licht.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libsForQt5.polkit-kde-agent
      libsForQt5.qtwayland
      qt6.qtwayland
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      networkmanagerapplet
    ];

    programs.hyprland.enable = true;

    services.pipewire.wireplumber.enable = true;

    security.pam.services.hyprlock = { };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
