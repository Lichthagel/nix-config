{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.qt;
in
{
  options.licht.graphical.qt = {
    enable = lib.mkEnableOption "qt";
  };

  config = lib.mkIf cfg.enable (
    let
      capitalize =
        str:
        (lib.toUpper (builtins.substring 0 1 str)) + (builtins.substring 1 (builtins.stringLength str) str);
      flavorCapitalized = capitalize config.catppuccin.flavor;
      accentCapitalized = capitalize config.catppuccin.accent;
      theme = pkgs.catppuccin-kvantum.override {
        accent = accentCapitalized;
        variant = flavorCapitalized;
      };
    in
    {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };

      xdg.configFile = {
        "Kvantum/Catppuccin-${flavorCapitalized}-${accentCapitalized}".source = "${theme}/share/Kvantum/Catppuccin-${flavorCapitalized}-${accentCapitalized}";
      };
    }
  );
}
