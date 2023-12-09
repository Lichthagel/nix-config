{pkgs, ...}: let
  afacad = pkgs.callPackage ../packages/afacad.nix {};
  gabarito = pkgs.callPackage ../packages/gabarito.nix {};
  lilex = pkgs.callPackage ../packages/lilex.nix {};
  monolisa = pkgs.callPackage ../packages/monolisa.nix {};
  monolisa-nerdfont = pkgs.callPackage ../packages/nerdfont.nix {font = monolisa;};
in {
  home.packages = with pkgs; [
    (google-fonts.override {
      fonts = [
        "M PLUS 1"
        "Outfit"
        "Sora"
        "Josefin Sans"
      ];
    })
    afacad
    gabarito
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    overpass
    ibm-plex
    inter
    jost
    open-sans
    cascadia-code
    fira-code
    jetbrains-mono
    lilex
    monolisa
    monolisa-nerdfont
    (pkgs.nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "FiraCode"
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];

  fonts.fontconfig.enable = true;
}
