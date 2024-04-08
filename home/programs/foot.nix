{
  config,
  lib,
  ctp,
  ...
}:
let
  cfg = config.licht.programs.foot;
in
{
  options.licht.programs.foot = {
    enable = lib.mkEnableOption "foot" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "Cascadia Code:size=11";
        };
        colors =
          let
            colors = lib.mapAttrs (name: value: lib.removePrefix "#" value.hex) ctp.palette.colors;
          in
          {
            foreground = colors.text;
            background = colors.base;
            regular0 = colors.surface1;
            regular1 = colors.red;
            regular2 = colors.green;
            regular3 = colors.yellow;
            regular4 = colors.blue;
            regular5 = colors.pink;
            regular6 = colors.teal;
            regular7 = colors.subtext1;
            bright0 = colors.surface2;
            bright1 = colors.red;
            bright2 = colors.green;
            bright3 = colors.yellow;
            bright4 = colors.blue;
            bright5 = colors.pink;
            bright6 = colors.teal;
            bright7 = colors.subtext0;
          };
      };
    };
  };
}
