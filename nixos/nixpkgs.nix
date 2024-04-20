{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.licht.unfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      List of package names that are allowed to be unfree.
    '';
  };

  config = {
    # needed in home configuration
    licht.unfreePackages = map lib.getName (
      with pkgs;
      [
        "code"
        discord
        obsidian
        spotify
        vscode
        zoom
      ]
    );

    nixpkgs.config = {
      allowUnfreePredicate =
        let
          whitelist = config.licht.unfreePackages;
        in
        pkg: builtins.elem (lib.getName pkg) whitelist;

      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
  };
}
