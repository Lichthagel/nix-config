{
  pkgs ? import <nixpkgs> {},
  font,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "${font.pname}-nerdfont";
  version = font.version;

  src = font;

  nativeBuildInputs = with pkgs; [
    nerd-font-patcher
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/fonts/truetype
    find . -name "*.ttf" -exec nerd-font-patcher -c -out "$out/share/fonts/truetype" {} \;
    chmod 644 $out/share/fonts/truetype/*.ttf

    runHook postBuild
  '';
}
