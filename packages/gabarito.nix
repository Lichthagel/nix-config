{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "gabarito";
  version = "1.000";

  src = pkgs.fetchzip {
    url = "https://github.com/naipefoundry/gabarito/releases/download/v${version}/gabarito-fonts.zip";
    sha256 = "sha256-hIK8YwxwUDnid6OnW2GyYYUDi72THMsWRj6w83s2lSc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/variable/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
