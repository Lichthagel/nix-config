{
  config,
  lib,
  ctp,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.licht.media.spotify;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  options.licht.media.spotify = {
    enable = lib.mkEnableOption "spotify";
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      theme =
        let
          spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
        in
        spicePkgs.themes.catppuccin
        // {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "spicetify";
            rev = "d3c4b697f1739149684e36977a1502f88c344b3a";
            sha256 = "sha256-VxkgW9qF1pmKnP7Ei7gobF0jVB1+qncfFeykWoXMRCo=";
          };
        };
      colorScheme = ctp.flavor;
    };
  };
}
