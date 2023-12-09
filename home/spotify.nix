{
  ctp,
  pkgs,
  spicetify-nix,
  ...
}: let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    # spotify
    spotifyd
    spotify-tui
    # spicetify-cli
  ];

  imports = [
    spicetify-nix.homeManagerModule
  ];

  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = ctp.flavor;
  };
}
