{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.programs.wezterm;
in
{
  options.licht.programs.wezterm = {
    enable = lib.mkEnableOption "wezterm";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm.overrideAttrs (finalAttrs: {
        patches = finalAttrs.patches ++ [ ./fix_kb.patch ];
      });
    };

    xdg.configFile = {
      "wezterm/wezterm.lua".source = ./.wezterm.lua;
    };
  };
}
