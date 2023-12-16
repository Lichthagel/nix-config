{
  pkgs,
  selfPkgs,
  ...
}: {
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
    noto-fonts-color-emoji
    open-sans
    overpass

    # code
    (nerdfonts.override {
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
    selfPkgs.lilex
    selfPkgs.monolisa
    selfPkgs.monolisa-nerdfont
  ];

  fonts.fontconfig.enable = true;
}
