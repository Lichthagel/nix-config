{
  pkgs,
  ctp,
  ...
}: {
  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = [ctp.flavor];
      accents = [ctp.accent];
    })
    (pkgs.catppuccin-papirus-folders.override {
      inherit (ctp) flavor accent;
    })
    pkgs.capitaine-cursors
    (pkgs.google-fonts.override {
      fonts = [
        "Outfit"
      ];
    })
  ];

  home.pointerCursor = {
    name = "Capitaine Cursors - White";
    # size = 32;
    package = pkgs.capitaine-cursors;
    gtk.enable = true;
    x11.enable = true;
  };
}
