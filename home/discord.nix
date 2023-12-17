{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ((discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      .overrideAttrs (oldAttrs:
        lib.optionalAttrs (config.i18n.inputMethod == "fcitx5") {
          installPhase =
            builtins.replaceStrings
            [''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"'']
            [''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" --add-flags --enable-wayland-ime'']
            oldAttrs.installPhase;
        }))
  ];
}
