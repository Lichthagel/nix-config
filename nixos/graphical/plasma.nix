{pkgs, ...}: {
  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    kate
    khelpcenter
    kwrited
    plasma-browser-integration
  ];
}
