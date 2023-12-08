{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "monolisa";
  version = "2.011";

  src = pkgs.requireFile {
    name = "MonoLisa-Plus-${version}.zip";
    url = "https://www.monolisa.dev/orders";
    sha256 = "sha256:6de35b7dfcb8dfb67a509888d7d70d7aa92bc489d7b05d7184cb80b5e8a5043f";
  };

  nativeBuildInputs = with pkgs; [
    unzip
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ttf/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
