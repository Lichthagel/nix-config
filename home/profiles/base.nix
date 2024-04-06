{ config, lib, ... }:
let
  enabled = config.licht.profiles.base;
in
{
  options.licht.profiles.base = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf enabled {
    licht = lib.mkDefault {
      editors = {
        helix.enable = true;
        neovim.enable = true;
      };
    };

    home = {
      sessionVariables = lib.mkIf config.licht.editors.helix.enable {
        EDITOR = "hx";
        VISUAL = "hx";
      };
    };
  };
}
