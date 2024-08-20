{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.graphical.sddm;
in
{
  options.licht.graphical.sddm = {
    enable = lib.mkEnableOption "sddm" // {
      default = config.licht.graphical.plasma5.enable || config.licht.graphical.plasma6.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      package = lib.mkDefault pkgs.kdePackages.sddm;
      enable = true;
      wayland.enable = true;
      catppuccin = {
        enable = true;
        background = config.licht.wallpaper;
      };
      settings = {
        Theme = {
          CursorTheme = "Vimix-white-cursors";
        };
      };
    };

    environment.systemPackages = [ pkgs.vimix-cursors ];
  };
}
