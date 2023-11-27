{
  lib,
  pkgs,
  ctp,
  ...
}: let
  # is there a better way?
  capitalize = s:
    lib.strings.concatStrings (
      lib.lists.imap0
      (i: v:
        if i == 0
        then lib.strings.toUpper v
        else v)
      (lib.strings.stringToCharacters s)
    );
in {
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-${capitalize ctp.flavor}-Standard-${capitalize ctp.accent}-Dark";
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
