{
  config,
  lib,
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

        theme = spicePkgs.themes.catppuccin;
        colorScheme = config.catppuccin.flavor;

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
