{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.podman.licht;
in
{
  options.virtualisation.podman.licht = {
    enable = lib.mkEnableOption "podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      containers = {
        enable = true;
        registries.search = [
          "docker.io"
          "ghcr.io"
          "quay.io"
        ];
      };
    };

    environment.systemPackages = [ pkgs.podman-compose ];
  };
}
