{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "catppuccin-sddm";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "529ec0f994c0e2527f118d17b143892f4d214575";
    sha256 = "sha256-gXUi6rBUr8ZGbUbo1/rMYIvbluKkyqqe+PMP3Xwf/kI=";
  };
  propagatedBuildInputs = with pkgs.libsForQt5.qt5; [
    qtgraphicaleffects
    qtsvg
    qtquickcontrols2
  ];
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    ls $src/src
    cp -r $src/src/* $out/share/sddm/themes/
  '';
}
