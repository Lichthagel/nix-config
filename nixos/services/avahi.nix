{ config, lib, ... }:
let
  cfg = config.services.avahi.licht;
in
{
  options.services.avahi.licht = {
    enable = lib.mkEnableOption "avahi";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
}
