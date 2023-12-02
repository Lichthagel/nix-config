{pkgs, ...}: {
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
  ];
}
