# Based on https://github.com/NixOS/nixpkgs/pull/296682 but using qt6 libraries
{
  pkgs ? import <nixpkgs> { },
  lib ? import <nixpkgs/lib> { },

  flavor ? "mocha",
  font ? "Noto Sans",
  fontSize ? "9",
  background ? null,
  loginBackground ? false,
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-sddm";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "v${version}";
    hash = "sha256-SdpkuonPLgCgajW99AzJaR8uvdCPi4MdIxS5eB+Q9WQ=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ pkgs.just ];

  propagatedBuildInputs = with pkgs.qt6; [
    qtsvg
    qtdeclarative
  ];

  buildPhase = ''
    just build
  '';

  installPhase = ''
    mkdir -p "$out/share/sddm/themes/"
    cp -r dist/catppuccin-${flavor} "$out/share/sddm/themes/catppuccin-${flavor}"

    configFile=$out/share/sddm/themes/catppuccin-${flavor}/theme.conf

    substituteInPlace $configFile \
      --replace-fail 'Font="Noto Sans"' 'Font="${font}"' \
      --replace-fail 'FontSize=9' 'FontSize=${fontSize}'

    ${lib.optionalString (background != null) ''
      substituteInPlace $configFile \
        --replace-fail 'Background="backgrounds/wall.jpg"' 'Background="${background}"' \
        --replace-fail 'CustomBackground="false"' 'CustomBackground="true"'
    ''}

    ${lib.optionalString loginBackground ''
      substituteInPlace $configFile \
        --replace-fail 'LoginBackground="false"' 'LoginBackground="true"'
    ''}
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${pkgs.qt6.qtsvg} >> $out/nix-support/propagated-user-env-packages
    echo ${pkgs.qt6.qtdeclarative} >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
