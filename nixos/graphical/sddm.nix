{pkgs, ...}: let
  catppuccin-sddm = import ../../packages/catppuccin-sddm.nix {inherit pkgs;};
in {
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };

  environment.systemPackages = [
    catppuccin-sddm
  ];
}
