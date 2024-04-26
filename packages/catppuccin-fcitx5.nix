{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "catppuccin-fcitx5";

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fcitx5";
    rev = "ce244cfdf43a648d984719fdfd1d60aab09f5c97";
    sha256 = "sha256-uFaCbyrEjv4oiKUzLVFzw+UY54/h7wh2cntqeyYwGps=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fcitx5/themes
    cp -Tr $src/src $out/share/fcitx5/themes
  '';
}
