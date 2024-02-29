{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "catppuccin-sddm";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "f3db13cbe8e99a4ee7379a4e766bc8a4c2c6c3dd";
    sha256 = "sha256-0zoJOTFjQq3gm5i3xCRbyk781kB7BqcWWNrrIkWf2Xk=";
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
