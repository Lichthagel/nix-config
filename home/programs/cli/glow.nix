{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.programs.cli.glow;
in
{
  options.licht.programs.cli.glow = {
    enable = lib.mkEnableOption "glow" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.glow ];

    programs.glamour.catppuccin.enable = true;

    xdg.configFile."glow/glow.yml".text = ''
      style: "${config.home.sessionVariables.GLAMOUR_STYLE}"
    '';
  };
}
