{ config, lib, ... }:
let
  cfg = config.licht.programs.rio;
in
{
  options.licht.programs.rio = {
    enable = lib.mkEnableOption "rio" // {
      default = config.licht.graphical.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rio = {
      enable = true;
      catppuccin.enable = true;

      settings = {
        window = {
          foreground-opacity = 1.0;
          background-opacity = 0.8;
        };

        renderer = {
          performance = "High";
          backend = "Vulkan";
        };

        fonts = {
          size = 20;
          family = "CaskaydiaCove Nerd Font Mono";
          extra = [ { family = "Symbols Nerd Font"; } ];
        };
      };
    };
  };
}
