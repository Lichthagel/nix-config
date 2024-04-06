{
  config,
  lib,
  ctp,
  ...
}:
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
      settings = {
        theme = "catppuccin_${ctp.flavor}";
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
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
