{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "monolisa";
  version = "2.014";

  src = pkgs.requireFile {
    name = "MonoLisa-Plus-${version}.zip";
    url = "https://www.monolisa.dev/orders";
    sha256 = "sha256-aFiTLVSn+WkyZM2Crzs+5uh/Ervrq2QPIFlqhgXloaI=";
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
