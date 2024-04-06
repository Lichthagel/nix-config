{ config, lib, ... }:
let
  cfg = config.licht.programs.wezterm;
in
{
  options.licht.programs.wezterm = {
    enable = lib.mkEnableOption "wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm.enable = true;

    xdg.configFile = {
      "wezterm/wezterm.lua".source = ./.wezterm.lua;
    };
  };
}
