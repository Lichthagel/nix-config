{pkgs, ...}: let
  afacad = pkgs.callPackage ../packages/afacad.nix {};
  gabarito = pkgs.callPackage ../packages/gabarito.nix {};
  lilex = pkgs.callPackage ../packages/lilex.nix {};
  monolisa = pkgs.callPackage ../packages/monolisa.nix {};
  monolisa-nerdfont = pkgs.callPackage ../packages/nerdfont.nix {font = monolisa;};
in {
  home.packages = with pkgs; [
    # sans-serif
    (google-fonts.override {
      fonts = [
        "Josefin Sans"
        "M PLUS 1"
        "Nunito"
        "Outfit"
        "Plus Jakarta Sans"
        "Rubik"
        "Sora"
      ];
    })
    afacad
    gabarito
    ibm-plex
    inter
    jost
    lexend
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    open-sans
    overpass

    # code
    (pkgs.nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
    cascadia-code
    fira-code
    jetbrains-mono
    lilex
    monolisa
    monolisa-nerdfont
  ];

  fonts.fontconfig.enable = true;
}
