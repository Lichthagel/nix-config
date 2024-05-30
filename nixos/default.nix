{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./graphical
    ./services

    ./nixpkgs.nix
    ./podman.nix
    ./sound.nix
    ./wireguard.nix
  ];

  config = {
    # Bootloader.
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      editor = false;
    };

    boot.loader.efi.canTouchEfiVariables = true;

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    networking.hosts =
      let
        hostName = config.networking.hostName;
      in
      lib.mkMerge [
        {
          "127.0.0.1" = [ "${hostName}.licht.moe" ];
          "::1" = [ "${hostName}.licht.moe" ];
        }
        (
          let
            homeNetwork = {
              jdnixos = [ "192.168.1.178" ];
              jnbnixos = [ "192.168.1.75" ];
            };
          in
          lib.mkIf (homeNetwork ? ${hostName}) (
            lib.mkMerge (
              lib.flatten (
                lib.mapAttrsToList (
                  hostname: addresses:
                  lib.forEach addresses (address: {
                    ${address} = [ "${hostname}.licht.moe" ];
                  })
                ) homeNetwork
              )
            )
          )
        )
      ];

    environment.etc."gai.conf".text = ''
      # default table

      label  ::1/128       0 # loopback
      label  ::/0          1 # any ipv6
      label  2002::/16     2 # 6to4
      label ::/96          3 # ipv4 compat (deprecated)
      label ::ffff:0:0/96  4 # ipv4 mapped
      precedence  ::1/128       50 # loopback
      precedence  ::/0          40 # any ipv6
      precedence  2002::/16     30 # 6to4
      precedence ::/96          20 # ipv4 compat (deprecated)
      precedence ::ffff:0:0/96  10 # ipv4 mapped

      # extra

      precedence ::ffff:192.168.1.0/120 45 # home ipv4
    '';

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "de_DE.UTF-8";

      supportedLocales = [
        "de_DE.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];

      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };

    # Configure console keymap
    console.keyMap = "neoqwertz";

    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    programs.ssh.startAgent = true;

    systemd.user.services.ssh-agent = {
      serviceConfig = {
        ExecStartPost = "${pkgs.systemd}/bin/systemctl --user set-environment SSH_AUTH_SOCK=%t/ssh-agent";
        ExecStopPost = "${pkgs.systemd}/bin/systemctl --user unset-environment SSH_AUTH_SOCK";
      };
    };

    services.dbus = {
      implementation = "broker";
    };

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      neovim
      helix
      git
      jq
    ];

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = (import ../flake.nix).nixConfig;
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
        unstable.flake = inputs.nixpkgs-unstable;
      };
    };
  };
}
