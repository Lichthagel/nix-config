{
  config,
  lib,
  pkgs,
  inputs',
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

    programs.hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.hyprland;
    };

    services.pipewire.wireplumber.enable = true;
  };
}
