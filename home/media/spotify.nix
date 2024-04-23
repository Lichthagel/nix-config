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
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.licht.media.spotify = {
    enable = lib.mkEnableOption "spotify";
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;

        theme = spicePkgs.themes.catppuccin // {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "spicetify";
            rev = "d3c4b697f1739149684e36977a1502f88c344b3a";
            sha256 = "sha256-VxkgW9qF1pmKnP7Ei7gobF0jVB1+qncfFeykWoXMRCo=";
          };
        };
        colorScheme = ctp.flavor;

        enabledExtensions = with spicePkgs.extensions; [ shuffle ];

        xpui = {
          Setting = {
            overwrite_assets = true;
            inject_theme_js = true;
            inject_css = true;
            replace_colors = true;
          };
          AdditionalOptions = {
            sidebar_config = true;
            home_config = true;
            experimental_features = true;
          };
        };
      };

    licht.unfreePackages = map lib.getName [ pkgs.spotify ];
  };
}
