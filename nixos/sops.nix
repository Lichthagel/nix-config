{
  self,
  config,
  pkgs,
  ...
}: let
  hostName = config.networking.hostName;
  homeDir = config.home-manager.users.licht.home.homeDirectory;
in {
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = "${self}/secrets.yaml";
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

    secrets = {
      "wireguard/${hostName}.env" = {};
      "ssh/shared/private" = {
        owner = config.users.users.licht.name;
        group = config.users.users.licht.group;
        mode = "0600";
        path = "${homeDir}/.ssh/id_ed25519_shared";
      };
    };
  };
}
