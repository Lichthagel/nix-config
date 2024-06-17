{ inputs', ... }:
{
  home-manager.users.licht.systemd.user.services.teruko = {
    Unit = {
      Description = "Teruko";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${inputs'.teruko-legacy.packages.teruko}/bin/teruko";
      Restart = "on-failure";
      RestartSec = "5";
      Environment = [
        "DATABASE_URL=postgresql://teruko:1234@127.0.0.1:5432/teruko?schema=public"
        "IMG_FOLDER=/mnt/d/teruko"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  networking.nftables.tables.nixos-fw.content = ''
    chain input-allow {
      iifname wg0 tcp dport { 3030 } accept
      ip saddr 192.168.1.0/24 tcp dport { 3030 } accept
    }
  '';
}
