{
  config,
  lib,
  ...
}:
let
  cfg = config.licht.programs.lazygit;
in
{
  options.licht.programs.lazygit = {
    enable = lib.mkEnableOption "lazygit";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      catppuccin.enable = true;
    };
  };
}
