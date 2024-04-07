{ config, lib, ... }:
let
  cfg = config.licht.editors.helix;
in
{
  options.licht.editors.helix = {
    enable = lib.mkEnableOption "helix" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
        };
      };
    };
  };
}
