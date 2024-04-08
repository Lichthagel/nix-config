{
  config,
  lib,
  pkgs,
  selfPkgs,
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
    services.xserver.displayManager.sddm = {
      package = pkgs.kdePackages.sddm;
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
    };

    environment.systemPackages = [ selfPkgs.catppuccin-sddm ];
  };
}
