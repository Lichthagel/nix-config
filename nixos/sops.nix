{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  hostName = config.networking.hostName;

  cfg = config.licht.sops;
in
{
  options.licht.sops = {
    enable = lib.mkEnableOption "sops";

    user = lib.mkOption {
      type = lib.types.str;
      default = "licht";
      description = "The user to use for sops";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops =
      let
        homeDir = config.home-manager.users.${cfg.user}.home.homeDirectory;
      in
      {
        defaultSopsFile = "${self}/secrets.yaml";
        age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

        secrets = {
          "wireguard/${hostName}.env" = { };
          "ssh/shared/private" = {
            owner = config.users.users.${cfg.user}.name;
            group = config.users.users.${cfg.user}.group;
            mode = "0600";
            path = "${homeDir}/.ssh/id_ed25519_shared";
          };
        };
      };
  };
}
