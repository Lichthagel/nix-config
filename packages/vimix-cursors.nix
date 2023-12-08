{pkgs, ...}:
pkgs.stdenvNoCC.mkDerivation {
  name = "vimix-cursors";

  src = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "vimix-cursors";
    rev = "2020-02-24";
    sha256 = "sha256-TfcDer85+UOtDMJVZJQr81dDy4ekjYgEvH1RE1IHMi4=";
  };

  # not needed since the repo includes prebuilt cursors
  # but kept here for reference

  # nativeBuildInputs = with pkgs; [
  #   (python3.withPackages (ps: with ps; [cairosvg]))
  #   xorg.xcursorgen
  # ];

  # postPatch = ''
  #   patchShebangs .
  # '';

  # buildPhase = ''
  #   runHook preBuild

  #   HOME="$NIX_BUILD_ROOT" ./build.sh

  #   runHook postBuild
  # '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r dist $out/share/icons/Vimix-cursors
    cp -r dist-white $out/share/icons/Vimix-white-cursors

    runHook postInstall
  '';
}
