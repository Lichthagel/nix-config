{ config, lib, ... }:
let
  cfg = config.licht.profiles;
in
{
  options.licht.profiles = {
    graphical = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.graphical {
    licht = lib.mkDefault {
      editors.vscode.enable = true;

      media = {
        mpv.enable = true;
        spotify.enable = true;
      };

      programs = {
        discord.enable = true;
        firefox.enable = true;
      };
    };
  };
}
