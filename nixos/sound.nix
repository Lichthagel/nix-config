{ config, lib, ... }:
let
  cfg = config.licht.sound;
in
{
  options.licht.sound = {
    enable = lib.mkEnableOption "sound support";

    useNoiseTorch = lib.mkOption {
      type = lib.types.bool;
      default = config.licht.graphical.enable;
      description = "Enable NoiseTorch for noise suppression";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    programs.noisetorch.enable = cfg.useNoiseTorch;
  };
}
