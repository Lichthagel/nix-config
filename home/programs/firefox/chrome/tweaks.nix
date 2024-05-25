{ config, lib, ... }:
let
  cfgChrome = config.programs.firefox.licht.chrome;
in
{
  options.programs.firefox.licht.chrome = {
    small_sidebar_header = lib.mkEnableOption "small sidebar header";
    no_sidebar_border = lib.mkEnableOption "no sidebar border";
  };

  config.programs.firefox.profiles.default.userChrome = lib.mkMerge [
    (lib.mkIf cfgChrome.small_sidebar_header ''
      /**
       * Taken from https://github.com/mbnuqw/sidebery/wiki/Firefox-Styles-Snippets-(via-userChrome.css)#decrease-size-of-the-sidebar-header
       *
       * Decrease size of the sidebar header
       */
      #sidebar-header {
        font-size: 1.2em !important;
        padding: 2px 6px 2px 3px !important;
      }
      #sidebar-header #sidebar-close {
        padding: 3px !important;
      }
      #sidebar-header #sidebar-close .toolbarbutton-icon {
        width: 14px !important;
        height: 14px !important;
        opacity: 0.6 !important;
      }
    '')
    (lib.mkIf cfgChrome.no_sidebar_border ''
      #sidebar-header {
        border-bottom: none !important;
      }
      @media not (-moz-platform: linux) {
        .sidebar-splitter {
          border-inline-end-width: 0 !important;
        }
      }
    '')
  ];
}
