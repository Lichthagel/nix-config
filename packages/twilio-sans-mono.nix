{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "twilio-sans-mono";

  src = pkgs.fetchzip {
    url = "https://github.com/twilio/twilio-sans-mono/raw/6bb29c96842f19a533401e6266fdfdd813dcf3e4/Twilio-Sans-Mono.zip";
    sha256 = "sha256-cUFAsB4pWsXhPvbuiFqXARTMYW+63rEGTwa8RNvuU84=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 TTF/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
