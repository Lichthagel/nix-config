{
  pkgs ? import <nixpkgs> {},
  font,
  ...
}:
pkgs.stdenvNoCC.mkDerivation (
  (
    if (font ? pname) && (font ? version)
    then {
      pname = "${font.pname}-nerdfont";
      version = font.version;
    }
    else {
      name = "${font.name}-nerdfont";
    }
  )
  // {
    src = font;

    nativeBuildInputs = with pkgs; [
      nerd-font-patcher
    ];

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/share/fonts/truetype
      find . -name "*.ttf" -exec nerd-font-patcher -c -out "$out/share/fonts/truetype" {} \;
      find . -name "$out/share/fonts/truetype/*.ttf" -exec chmod 644 {} \;

      mkdir -p $out/share/fonts/opentype
      find . -name "*.otf" -exec nerd-font-patcher -c -out "$out/share/fonts/opentype" {} \;
      find . -name "$out/share/fonts/opentype/*.otf" -exec chmod 644 {} \;

      runHook postBuild
    '';
  }
)
