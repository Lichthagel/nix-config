{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.sway.licht;
in
{
  options.programs.sway.licht = {
    enable = lib.mkEnableOption "sway";
  };

  config = lib.mkIf cfg.enable {
    # TODO just copied from hyprland
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

    programs.sway = {
      enable = true;
      extraSessionCommands =
        let
          toShellVars = vars: lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "export ${n}=${v}") vars);
        in
        toShellVars {
          SDL_VIDEODRIVER = "wayland";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          _JAVA_AWT_WM_NONREPARENTING = "1";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
          WLR_RENDERER = "vulkan";
          WLR_NO_HARDWARE_CURSORS = "1";
          XWAYLAND_NO_GLAMOR = "1";
        };
    };

    xdg.portal = {
      wlr.enable = lib.mkForce true;
      config.sway = {
        default = [
          "wlr"
          "kde"
        ];
      };
      extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
    };
  };
}
