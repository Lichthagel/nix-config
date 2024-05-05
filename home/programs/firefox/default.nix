{ config, lib, ... }:
let
  cfg = config.licht.programs.firefox;
in
{
  options = {
    licht.programs.firefox = {
      enable = lib.mkEnableOption "my firefox config";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        settings = builtins.import ./settings.nix;
      };
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
