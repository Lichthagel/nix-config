{
  config,
  lib,
  pkgs,
  ...
}:
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
      extensions = with pkgs; [
        gh-copilot
        gh-poi
      ];
    };

    licht.unfreePackages = map lib.getName [ pkgs.gh-copilot ];

    programs.gh-dash = {
      enable = true;
      catppuccin.enable = true;
    };

    programs.glamour.catppuccin.enable = true;
  };
}
