{pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    khelpcenter
    kwrited
    plasma-browser-integration
  ];
}
