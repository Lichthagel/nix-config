{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical;
in
{
  imports = [
    ./fcitx5.nix
    ./hyprland.nix
    ./plasma5.nix
    ./plasma6.nix
    ./sddm.nix
    ./sway.nix
  ];

  options.licht.graphical = {
    enable = lib.mkEnableOption "graphical environment";
  };

  config = lib.mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "neo_qwertz";
    };

    environment.systemPackages = with pkgs; [ wl-clipboard ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
