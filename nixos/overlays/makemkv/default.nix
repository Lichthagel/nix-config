{ lib, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      libbluray = prev.libbluray.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ final.makemkv ];

        preFixup = ''
          patchelf $out/lib/libbluray.so \
            --add-needed ${final.makemkv}/lib/libmmbd.so.0
        '';
      });
      makemkv = prev.makemkv.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [ ./appdir.patch ];

        postPatch = ''
          substituteInPlace makemkvgui/src/api_linux.cpp --replace '%MAKEMKV_BIN%' $out/bin;
        '';
      });
    })
  ];

  licht.unfreePackages = map lib.getName [ pkgs.makemkv ];
}
