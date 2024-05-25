{
  config,
  lib,
  pkgs,
  ...
}:
let
  hacks = config.programs.firefox.licht.chrome.csshacks;

  csshacks = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "firefox-csshacks";
    rev = "4e474a7191bd0a5f1526a256443e75b1655302ee";
    sha256 = "sha256-rQcSeaGd/KdpMHp4s3AYaLm3Z28StTSa/4LaiAaB4Xw=";
  };
in
{
  options.programs.firefox.licht.chrome.csshacks = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      A set of CSS hacks to apply to the Firefox Licht theme.
    '';
  };

  config.programs.firefox.profiles.default.userChrome = lib.mkBefore (
    lib.concatMapStringsSep "\n" (hack: "@import url(\"${csshacks}/chrome/${hack}.css\");") hacks
  );
}
