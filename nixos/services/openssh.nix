{ config, lib, ... }:
let
  cfg = config.licht.services.openssh;
in
{
  options.licht.services.openssh = {
    enable = lib.mkEnableOption "openssh";

    authorizedKeys = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {
        licht = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINk7AyWZXm9YSmnwfW0M6ujtqc0mg3ZUcW0X0NbyHS7 shared"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users = lib.mapAttrs (name: value: { openssh.authorizedKeys.keys = value; }) cfg.authorizedKeys;
  };
}
