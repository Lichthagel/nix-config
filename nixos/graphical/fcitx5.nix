{ pkgs, selfPkgs, ... }:
{
  i18n = {
    # probably not needed, but might fix some quirks
    supportedLocales = [ "ja_JP.UTF-8/UTF-8" ];

    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        selfPkgs.catppuccin-fcitx5
      ];
    };
  };
}
