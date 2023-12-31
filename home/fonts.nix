{
  pkgs,
  selfPkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    # sans-serif
    (google-fonts.override {
      fonts = [
        "Josefin Sans"
        "M PLUS 1"
        "M PLUS 1 Code"
        "M PLUS 2"
        "Nunito"
        "Outfit"
        "Plus Jakarta Sans"
        "Rubik"
        "Sen"
        "Sora"
      ];
    })
    selfPkgs.afacad
    selfPkgs.gabarito
    ibm-plex
    inter
    jost
    lexend
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    open-sans
    overpass

    # code
    (unstablePkgs.nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "FiraCode"
        "JetBrainsMono"
        "Monaspace"
        "NerdFontsSymbolsOnly"
        "VictorMono"
      ];
    })
    cascadia-code
    fira-code
    jetbrains-mono
    selfPkgs.lilex
    monaspace
    selfPkgs.monolisa
    selfPkgs.monolisa-nerdfont
    victor-mono
  ];

  fonts.fontconfig.enable = true;
}
