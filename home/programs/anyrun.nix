{
  config,
  lib,
  inputs,
  inputs',
  ...
}:
let
  cfg = config.licht.programs.anyrun;
in
{
  imports = [ inputs.anyrun.homeManagerModules.default ];

  options.licht.programs.anyrun = {
    enable = lib.mkEnableOption "anyrun" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs'.anyrun.packages; [ applications ];
        x = {
          fraction = 0.5;
        };
        y = {
          fraction = 0.3;
        };
        width = {
          fraction = 0.3;
        };
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
      };
      extraCss = ''
        window {
          background: transparent;
        }
      '';
    };
  };
}
