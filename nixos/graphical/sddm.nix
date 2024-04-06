{
  config,
  lib,
  selfPkgs,
  ...
}:
let
  cfg = config.licht.graphical.sddm;
in
{
  options.licht.graphical.sddm = {
    enable = lib.mkEnableOption "sddm" // {
      default = config.licht.graphical.plasma5.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
    };

    environment.systemPackages = [ selfPkgs.catppuccin-sddm ];
  };
}
