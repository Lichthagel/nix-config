{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wayland.windowManager.sway.licht;
in
{
  options.wayland.windowManager.sway.licht = {
    enable = lib.mkEnableOption "sway" // {
      default = osConfig.programs.sway.licht.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ nwg-look ];

    licht.autostart.systemd = lib.mkDefault true;

    systemd.user.targets.sway-session.Unit.Wants = lib.mkIf config.licht.autostart.systemd [
      "autostart.target"
    ];

    wayland.windowManager.sway = {
      enable = true;
      catppuccin.enable = true;
      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      config = {
        startup = [
          { command = "${pkgs.kdePackages.kwallet}/bin/kwalletd6"; }
          { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; }
        ];
        menu = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
        input = {
          "type:keyboard" = {
            xkb_layout = "de";
            xkb_variant = "neo_qwertz";
          };
          "type:touchpad" = {
            natural_scroll = "enabled";
            tap = "enabled";
          };
        };
        modifier = "Mod4";
        bars = [ ];
      };
    };
  };
}
