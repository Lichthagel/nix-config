{pkgs, ...}: let
  lilex = import ../packages/lilex.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    (google-fonts.override {
      fonts = [
        "M PLUS 1"
        "Outfit"
        "Sora"
      ];
    })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    cascadia-code
    fira-code
    jetbrains-mono
    lilex
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
