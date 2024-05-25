{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  enabled = config.licht.profiles.graphical;
in
{
  options.licht.profiles.graphical = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf enabled {
    licht = lib.mkMerge [
      (lib.mkDefault {
        profiles.base = true;

        graphical = {
          gtk.enable = true;
          qt.enable = true;
        };

        editors = {
          vscode.enable = true;
        };

        media = {
          mpv.enable = true;
          spotify.enable = true;
        };

        programs = {
          discord.enable = true;
          wezterm.enable = true;
        };
      })
      {
        unfreePackages = map lib.getName [ pkgs.obsidian ];

        autostart.entries = lib.mkMerge [
          {
            keepassxc = {
              description = "KeePassXC";
              command = "${pkgs.keepassxc}/bin/keepassxc";
            };
          }
          (lib.mkIf osConfig.services.mullvad-vpn.enable {
            mullvad-vpn = {
              description = "Mullvad VPN";
              command = "${pkgs.mullvad-vpn}/bin/mullvad-vpn";
            };
          })
        ];
      }
    ];

    programs = {
      firefox.licht = {
        enable = true;
        chrome = {
          small_sidebar_header = true;
          no_sidebar_border = true;

          csshacks = [
            "window_control_placeholder_support"
            "hide_tabs_toolbar"
          ];
        };
      };
    };

    systemd.user.services = {
      keepassxc = {
        Unit.After = [ "ssh-agent.service" ];
      };
    };

    home.packages = with pkgs; [
      keepassxc
      yubioath-flutter
      (obsidian.overrideAttrs (
        oldAttrs:
        lib.optionalAttrs (osConfig.i18n.inputMethod.enabled == "fcitx5") {
          installPhase =
            builtins.replaceStrings
              [ ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"'' ]
              [
                ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}" --add-flags --enable-wayland-ime''
              ]
              oldAttrs.installPhase;
        }
      ))
      thunderbird
    ];
  };
}
