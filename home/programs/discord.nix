{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.programs.discord;
in
{
  options.licht.programs.discord = {
    enable = lib.mkEnableOption "discord";
  };

  config = lib.mkIf cfg.enable (
    let
      discord = (
        (pkgs.discord.override {
          withOpenASAR = true;
          withVencord = true;
        }).overrideAttrs
          (
            oldAttrs:
            lib.optionalAttrs (osConfig.i18n.inputMethod.enabled == "fcitx5") {
              installPhase =
                builtins.replaceStrings
                  [
                    ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"''
                  ]
                  [
                    ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" --add-flags --enable-wayland-ime''
                  ]
                  oldAttrs.installPhase;
            }
          )
      );
    in
    {
      home.packages = [ discord ];

      licht.unfreePackages = map lib.getName [ discord ];
    }
  );
}
