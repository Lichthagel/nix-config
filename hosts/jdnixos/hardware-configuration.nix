# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    resumeDevice = "/dev/mapper/swapDevice";

    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
      luks.devices = {
        "rootDevice".device =
          "/dev/disk/by-uuid/aef8453d-65b8-4ade-bd05-948bfcd87b57";
        "swapDevice" = {
          device = "/dev/disk/by-uuid/1165a30d-7382-4aa1-be4d-db0313fd572c";
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/rootDevice";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1475-F6A1";
      fsType = "vfat";
    };

    "/mnt/d" = {
      device = "/dev/disk/by-uuid/42AAFF97AAFF8627";
      fsType = "ntfs3";
      options = [
        "rw"
        "uid=1000"
        "gid=1000"
        "umask=022"
        "fmask=133"
        "dmask=022"
        "prealloc"
        "windows_names"
      ];
    };

    "/mnt/e" = {
      device = "/dev/disk/by-uuid/66E8F3AFE8F37B9D";
      fsType = "ntfs3";
      options = [
        "rw"
        "uid=1000"
        "gid=1000"
        "umask=022"
        "fmask=133"
        "dmask=022"
        "prealloc"
        "windows_names"
      ];
    };
  };

  swapDevices = [{ device = "/dev/mapper/swapDevice"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
