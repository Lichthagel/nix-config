{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
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
    env = [
      "WLR_NO_HARDWARE_CURSORS,1"
      "WLR_DRM_DEVICES,$XDG_CONFIG_HOME/hypr/card"
    ];
    monitor = [
      "DP-2,3440x1440@144,1920x0,1"
      "DP-3,1920x1080@60,0x180,1"
    ];
  };

  wayland.windowManager.sway = {
    licht.perMonitorWorkspaces = true;
    extraOptions = [ "--unsupported-gpu" ];
    config = {
      output = {
        Unknown-1 = {
          disable = "";
        };
        DP-1 = {
          mode = "3440x1440@144Hz";
          position = "1920 0";
          scale = "1";
        };
        DP-3 = {
          mode = "1920x1080@60Hz";
          position = "0 180";
          scale = "1";
        };
      };
    };
  };

  home.activation = {
    hyprCardLink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -sf $VERBOSE_ARG \
          /dev/dri/by-path/pci-0000:26:00.0-card $XDG_CONFIG_HOME/hypr/card
    '';
  };

  services = {
    mako.output = "DP-2";
    swayidle.licht.suspend.enable = false;
  };

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
