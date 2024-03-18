{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "Cartograph CF";

  src = pkgs.requireFile {
    name = "Cartograph-CF";
    url = "https://connary.com/cartograph.html";
    sha256 = "sha256:1d6zbq0pmb9fzh87gasc4ks75fz3f6fc69gxlrzg09xfzhrlzzqj";
    hashMode = "recursive";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';
}
