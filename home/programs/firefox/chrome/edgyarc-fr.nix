{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = config.programs.firefox.licht.chrome.edgyarc-fr;

  edgyarc-fr = pkgs.fetchFromGitHub {
    owner = "artsyfriedchicken";
    repo = "EdgyArc-fr";
    rev = "v1.0.0-beta.11";
    sha256 = "sha256-Fz+4aFjIOQJ97ePJepQVvoSFdQ/cl56+w+49O8J8bNI=";
  };
in
{
  options.programs.firefox.licht.chrome.edgyarc-fr = lib.mkEnableOption "edgyarc-fr";

  config = lib.mkIf enable {
    programs.firefox.profiles.default = {
      settings = {
        "uc.tweak.floating-tabs" = true;
        "uc.tweak.rounded-corners" = true;
        "uc.tweak.hide-tabs-bar" = true;
        "uc.tweak.theme.sidebery" = false;
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

        "af.edgyarc.thin-navbar" = false;
        "af.edgyarc.minimal-navbar" = false;
        "uc.tweak.af.greyscale-webext-icons" = true;
        "af.edgyarc.centered-url" = true;
        "af.sidebery.edgyarc-theme" = true;
        "af.sidebery.minimal-collapsed" = true;
        "af.edgyarc.edge-sidebar" = false;
        "af.edgyarc.show-sidebar-header" = true;
        "af.edgyarc.autohide-sidebar" = false;
        "af.edgyarc.sidebar-always-collapsed" = false;
        "uc.tweak.af.sidebar-width-350" = false;
        "af.sidebery.nav-on-top" = true;
        "af.sidebery.static-pinned-tab-width" = false;
      };

      userChrome = lib.mkBefore ''
        @import url("${edgyarc-fr}/chrome/userChrome.css");
      '';

      userContent = lib.mkBefore ''
        @import url("${edgyarc-fr}/chrome/userContent.css");
      '';
    };
  };
}
