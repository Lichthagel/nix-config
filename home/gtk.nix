{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = ["pink"];
      };
    };
    cursorTheme = {
      name = "Capitaine Cursors - White";
      package = pkgs.capitaine-cursors;
    };
    font = {
      name = "Outfit";
      package = pkgs.google-fonts.override {
        fonts = ["Outfit"];
      };
    };
  };
}
