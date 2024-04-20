{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.programs.cli.bat;
in
{
  options.licht.programs.cli.bat = {
    enable = lib.mkEnableOption "bat" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      catppuccin.enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        prettybat
      ];
    };

    home.shellAliases = {
      cat = "bat";
    };
  };
}
