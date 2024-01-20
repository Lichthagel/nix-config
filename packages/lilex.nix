{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "lilex";
  version = "2.400";

  src = pkgs.fetchzip {
    url = "https://github.com/mishamyrt/Lilex/releases/download/${version}/Lilex.zip";
    stripRoot = false;
    sha256 = "sha256-7ZPLWJNVlnEZwWN1l5FsWDdYxKBq01GYrlLTmcjCQ9Y=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 variable/*-VF.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
