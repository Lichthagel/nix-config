{pkgs, ...}: {
  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["pink"];
    })
    pkgs.capitaine-cursors
  ];

  home.pointerCursor = {
    name = "Capitaine Cursors - White";
    # size = 32;
    package = pkgs.capitaine-cursors;
    gtk.enable = true;
    x11.enable = true;
  };
}
