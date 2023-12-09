{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "afacad";

  src = pkgs.fetchFromGitHub {
    owner = "Dicotype";
    repo = "Afacad";
    rev = "2864ef6847f274b7ac8649a82c455d846355ac19";
    sha256 = "sha256-3N4Bt2p6PkmnY0XkpiNpEMAwe8dzH/x4EjTs445tqNw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/variable/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
