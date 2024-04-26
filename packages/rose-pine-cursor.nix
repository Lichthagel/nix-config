{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "rose-pine-cursor";

  src = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "cursor";
    rev = "b38689c6c7ed4e6c04dd14d26eef7c0a5cc8a6ae";
    sha256 = "sha256-nPGkP8FQG71jInbM+w5zPHc7RfHnWG7hQq2ddmmooHE=";
  };

  nativeBuildInputs = with pkgs; [
    bun
    (python3.withPackages (ps: [ ps.clickgen ]))
  ];

  bunDeps = pkgs.stdenvNoCC.mkDerivation {
    name = "${name}-bun-deps";

    inherit src;

    nativeBuildInputs = with pkgs; [ bun ];

    configurePhase = ''
      runHook preConfigure

      export HOME=$(mktemp -d)

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bun install

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r node_modules $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-CztpS/j5sX0bwtPaYC+EyznOuuTE6HsxnM1uthiNOXI=";
    outputHashAlgo = "sha256";
  };

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    cp -Tr $bunDeps .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # echo 'running cbmp'
    # bunx cbmp -d 'svg' -o 'out/BreezeX-RoséPine' -bc '#191724' -oc '#e0def4'
    # bunx cbmp -d 'svg' -o 'out/BreezeX-RoséPineDawn' -bc '#faf4ed' -oc '#575279'

    echo 'running ctgen'
    ctgen build.toml -d 'bitmaps/BreezeX-RoséPine' -n 'BreezeX-RoséPine' -c 'Rosé Pine BreezeX cursors.'
    ctgen build.toml -d 'bitmaps/BreezeX-RoséPineDawn' -n 'BreezeX-RoséPineDawn' -c 'Rosé Pine Dawn BreezeX cursors.'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r themes/BreezeX-RoséPine $out/share/icons
    cp -r themes/BreezeX-RoséPineDawn $out/share/icons

    runHook postInstall
  '';
}
