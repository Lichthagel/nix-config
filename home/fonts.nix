{
  pkgs,
  selfPkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    # sans & mono
    unstablePkgs.geist-font

    # sans
    (google-fonts.override {
      fonts = [
        "Josefin Sans"
        "Josefin Slab"
        "M PLUS 1"
        "M PLUS 1 Code"
        "M PLUS 2"
        "Outfit"
        "Plus Jakarta Sans"
        "Rubik"
        "Sen"
        "Sora"
      ];
    })
    selfPkgs.afacad
    selfPkgs.gabarito
    inter
    jost
    lexend
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    overpass

    # mono
    (unstablePkgs.nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "FantasqueSansMono"
        "FiraCode"
        "GeistMono"
        # "Iosevka"
        "JetBrainsMono"
        "MartianMono"
        "Monaspace"
        "NerdFontsSymbolsOnly"
        "SourceCodePro"
        # "VictorMono"
      ];
    })
    cascadia-code
    selfPkgs.cartograph-cf
    selfPkgs.cartograph-cf-nerdfont
    fantasque-sans-mono
    fira-code
    # iosevka-bin
    jetbrains-mono
    unstablePkgs.kode-mono
    selfPkgs.kode-mono-nerdfont
    selfPkgs.lilex
    martian-mono
    monaspace
    selfPkgs.monolisa
    selfPkgs.monolisa-custom
    selfPkgs.monolisa-nerdfont
    selfPkgs.monolisa-custom-nerdfont
    # recursive
    # selfPkgs.recursive-nerdfont
    source-code-pro
    selfPkgs.twilio-sans-mono
    selfPkgs.twilio-sans-mono-nerdfont
    # victor-mono
  ];

  fonts.fontconfig.enable = true;
}
