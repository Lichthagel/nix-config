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
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    programs.noisetorch.enable = cfg.useNoiseTorch;
  };
}
