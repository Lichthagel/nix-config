{ config, lib, ... }:
let
  cfg = config.licht.programs.tofi;
in
{
  options.licht.programs.tofi = {
    enable = lib.mkEnableOption "tofi" // {
      default = config.licht.graphical.hyprland.enable || config.wayland.windowManager.sway.licht.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        font = "CaskaydiaCove Nerd Font";
        font-features = "calt, ss01";

        text-cursor-style = "bar";

        prompt-text = " ";
        prompt-padding = 20;
        num-results = 0;
        result-spacing = 5;

        width = 1280;
        height = 720;
        outline-width = 0;
        border-width = 0;
        padding-top = 20;
        padding-bottom = 20;
        padding-left = 20;
        padding-right = 20;
        clip-to-padding = true;

        hide-cursor = true;
        text-cursor = true;
        matching-algorithm = "fuzzy";
      };
    };
  };
}
