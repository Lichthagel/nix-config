{
  pkgs,
  ctp,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-${ctp.flavorCapitalized}-Standard-${ctp.accentCapitalized}-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = ctp.flavor;
        accents = [ctp.accent];
      };
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
    };
    font = {
      name = "Outfit";
      package = pkgs.google-fonts.override {
        fonts = ["Outfit"];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = ctp.flavor;
        accent = ctp.accent;
      };
    };
  };
}
