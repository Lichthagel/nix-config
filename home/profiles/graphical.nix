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
    licht = lib.mkDefault {
      profiles.base = true;

      editors = {
        vscode.enable = true;
      };

      media = {
        mpv.enable = true;
        spotify.enable = true;
      };

      programs = {
        discord.enable = true;
        firefox.enable = true;
        wezterm.enable = true;
      };
    };

    home = {
      packages = with pkgs; [
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
  };
}
