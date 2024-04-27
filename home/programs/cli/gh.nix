{ config, lib, ... }:
let
  cfg = config.licht.programs.cli.gh;
in
{
  options.licht.programs.cli.gh = {
    enable = lib.mkEnableOption "gh" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
        };
      };
    };

    programs.gh-dash = {
      enable = true;
    };

    programs.glamour.catppuccin.enable = true;
  };
}
