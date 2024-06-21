{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  cfg = config.licht.graphical.hyprland;

  # taken from plasma6 nixos module
  activationScript = ''
    # will be rebuilt automatically
    rm -fv $HOME/.cache/ksycoca*
  '';
in
{
  options.licht.graphical.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        kitty
        libsForQt5.qt5ct
        networkmanagerapplet
      ]
      ++ (with kdePackages; [
        ark
        dolphin
        dolphin-plugins
        ffmpegthumbs
        gwenview
        kdegraphics-thumbnailers
        kfilemetadata
        kimageformats
        kio
        kio-admin
        kio-extras
        kio-fuse
        kservice
        libheif
        okular
        polkit-kde-agent
        plasma-workspace
        qt6ct
        qtimageformats
        qtwayland
      ]);

    # fix file associations
    environment.variables = {
      XDG_MENU_PREFIX = "plasma-";
    };

    # taken from plasma6 nixos module
    system.userActivationScripts.rebuildSycoca = activationScript;
    systemd.user.services.nixos-rebuild-sycoca = {
      description = "Rebuild KDE system configuration cache";
      wantedBy = [ "graphical-session-pre.target" ];
      serviceConfig.Type = "oneshot";
      script = activationScript;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs'.hyprland.packages.default;
    };

    services.pipewire.wireplumber.enable = true;

    services.power-profiles-daemon.enable = lib.mkDefault true;
    services.udisks2.enable = true;

    security.pam.services.hyprlock = { };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
      config = {
        hyprland = {
          default = [
            "hyprland"
            "kde"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };
      };
      configPackages = lib.mkForce [ ];
    };
  };
}
