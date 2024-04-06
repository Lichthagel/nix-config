{ config, lib, ... }:
let
  cfg = config.licht.profiles;
in
{
  options.licht.profiles = {
    base = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    graphical = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.base {
      licht = lib.mkDefault {
        editors = {
          helix.enable = true;
          neovim.enable = true;
        };
      };
    })
    (lib.mkIf cfg.graphical {
      licht = lib.mkDefault {
        profiles.base = true;

        editors = {
          vscode.enable = true;
        };

        media = {
          mpv.enable = true;
          spotify.enable = true;
        };

        programs = {
          discord.enable = true;
          firefox.enable = true;
        };
      };
    })
  ];
}
