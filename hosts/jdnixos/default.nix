# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../nixos/base.nix
    ../../nixos/sops.nix
    # ../../nixos/unbound.nix
    ../../nixos/adguardhome.nix
    ../../nixos/graphical/base.nix
    ../../nixos/graphical/fcitx5.nix
    ../../nixos/graphical/sddm.nix
    ../../nixos/graphical/plasma.nix
    ../../nixos/sound.nix
    ../../nixos/wireguard.nix
    ../../nixos/ssh.nix
    ./gitea.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "jdnixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # services.auto-cpufreq.enable = true;

  # hardware.bluetooth.enable = true;

  services.pcscd.enable = true;

  boot.kernelModules = ["sg"];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.licht = {
    isNormalUser = true;
    description = "Jens";
    extraGroups = ["networkmanager" "wheel" "input"];
    shell = pkgs.zsh;
  };

  virtualisation.podman = {
    enable = true;

    dockerCompat = true;

    defaultNetwork.settings.dns_enabled = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    authentication = ''
      #type database user auth-method
      local all all trust

      host all all 127.0.0.1/32 scram-sha-256
      host all all ::1/128 scram-sha-256
    '';
    initdbArgs = [
      "--locale=C"
      "--encoding=UTF8"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  sops.secrets."nix_cache/${config.networking.hostName}/private" = {};

  nix.settings.secret-key-files = config.sops.secrets."nix_cache/${config.networking.hostName}/private".path;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [3030 22000];
  networking.firewall.allowedUDPPorts = [21027 22000];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
