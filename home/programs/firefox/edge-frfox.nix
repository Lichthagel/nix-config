{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = config.programs.firefox.licht.edge-frfox;

  edge-frfox = pkgs.fetchFromGitHub {
    owner = "bmFtZQ";
    repo = "edge-frfox";
    rev = "v24.4.18";
    sha256 = "sha256-MYaSEjBryKeW9piYp/j58Y8nq6RQRXqRxXgCWfwjWsQ=";
  };
in
{
  options.programs.firefox.licht = {
    edge-frfox = lib.mkEnableOption "edge-frfox" // {
      default = config.programs.firefox.licht.enable;
    };
  };

  config = lib.mkIf enable {
    programs.firefox.profiles.default.settings = {
      "uc.tweak.floating-tabs" = true;
      "uc.tweak.rounded-corners" = true;
      "uc.tweak.hide-tabs-bar" = true;
      "uc.tweak.theme.sidebery" = true;
      "uc.tweak.disable-drag-space" = true;
      "uc.tweak.newtab-background" = false;
      "uc.tweak.hide-forward-button" = true;
      "uc.tweak.hide-newtab-logo" = true;
      "uc.tweak.force-tab-colour" = false;
      "uc.tweak.vertical-context-navigation" = false;
      "uc.tweak.context-menu.hide-access-key" = true;
      "uc.tweak.remove-tab-separators" = true;
      "uc.tweak.show-tab-close-button-on-hover" = true;
      "uc.tweak.smaller-context-menu-text" = true;
      "uc.tweak.revert-context-menu" = false;
      "uc.tweak.context-menu.hide-firefox-account" = false;
      "uc.tweak.context-menu.compact-extensions-menu" = true;
    };

    home.file.".mozilla/firefox/default/chrome".source = "${edge-frfox}/chrome";
  };
}
