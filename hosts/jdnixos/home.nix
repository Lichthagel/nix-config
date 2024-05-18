{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [ ./teruko.nix ];

  home.packages = with pkgs; [
    calibre
    anki
    qbittorrent
    libreoffice-qt
    zoom-us
    rclone
  ];

  licht.unfreePackages = map lib.getName [ pkgs.zoom-us ];

  licht.profiles.graphical = true;
  licht.graphical.hyprland.perMonitorWorkspaces = true;
  licht.graphical.hypridle.suspend.enable = false;
  licht.graphical.hypridle.suspend.timeout = 30 * 60;
  licht.autostart.entries.discord.enable = true;

  wayland.windowManager.hyprland.settings = {
    env = [ "WLR_NO_HARDWARE_CURSORS,1" ];
    monitor = [
      "DP-2,3440x1440@144,1920x0,1"
      "DP-3,1920x1080@60,0x180,1"
    ];
  };

  services.mako.output = "DP-2";

  age = {
    secrets = {
      "ssh/id_ed25519_shared" = {
        file = self + /secrets/ssh/id_ed25519_shared;
        path = "${config.home.homeDirectory}/.ssh/id_ed25519_shared";
        mode = "0600";
      };
    };

    identityPaths = [ "${config.home.homeDirectory}/.config/sops/age/keys.txt" ];
  };

  xdg.userDirs = {
    enable = true;
    documents = "/mnt/d/Documents";
    download = "/mnt/d/Downloads";
    music = "/mnt/d/Music";
    pictures = "/mnt/d/Pictures";
    videos = "/mnt/d/Videos";
  };
}
