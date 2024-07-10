{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "Cartograph CF";

  src = pkgs.requireFile {
    name = "Cartograph-CF";
    url = "https://connary.com/cartograph.html";
    sha256 = "sha256-c5n9cRY9G1NduWvSsm7vVuxSNWJYvWdqalgqsX9bviw=";
    hashMode = "recursive";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';
}
