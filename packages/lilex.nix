{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "lilex";
  version = "2.300";

  src = pkgs.fetchzip {
    url = "https://github.com/mishamyrt/Lilex/releases/download/${version}/Lilex.zip";
    stripRoot = false;
    sha256 = "sha256-kr/aXrKo5cqhjrpNO+WFXUQxJOqUU9Tjz+Hdf61XSn0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 variable/*-VF.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
