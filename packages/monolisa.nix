{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "monolisa";
  version = "2.012";

  src = pkgs.requireFile {
    name = "MonoLisa-Plus-${version}.zip";
    url = "https://www.monolisa.dev/orders";
    sha256 = "sha256:a241f30e49f373f672a99271e25923df2eedd51e1ebab33fc14dc451972274ab";
  };

  nativeBuildInputs = with pkgs; [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ttf/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
