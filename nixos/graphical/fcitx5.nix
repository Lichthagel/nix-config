{
  config,
  lib,
  pkgs,
  selfPkgs,
  ...
}:
let
  cfg = config.licht.graphical.fcitx5;
in
{
  options.licht.graphical.fcitx5 = {
    enable = lib.mkEnableOption "fcitx5" // {
      default = config.licht.graphical.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    i18n = {
      # probably not needed, but might fix some quirks
      supportedLocales = [ "ja_JP.UTF-8/UTF-8" ];

      inputMethod = {
        enabled = "fcitx5";
        fcitx5 = {
          plasma6Support = true;
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
            kdePackages.fcitx5-qt
            selfPkgs.catppuccin-fcitx5
          ];
        };
      };
    };
  };
}
