{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "catppuccin-sddm";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
    sha256 = "sha256-Jf4xfgJEzLM7WiVsERVkj5k80Fhh1edUl6zsSBbQi6Y=";
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
