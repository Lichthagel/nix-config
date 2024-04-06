{ config, lib, ... }:
let
  cfg = config.licht.services.unbound;
in
{
  options = {
    licht.services.unbound = {
      enable = lib.mkEnableOption "unbound";
    };
  };

  config = lib.mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = "yes";
            forward-addr = "5.9.164.112@853#dns3.digitalcourage.de";
          }
        ];
        remote-control = {
          control-enable = true;
          control-use-cert = false;
        };
      };
    };
  };
}
