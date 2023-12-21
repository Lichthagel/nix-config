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
      "wireguard/private/${hostName}" = {};
      "wireguard/preshared/${hostName}" = {};
    };
  };
}
