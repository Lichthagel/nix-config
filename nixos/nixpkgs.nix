{ config, lib, ... }:
{
  options.licht.unfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      List of package names that are allowed to be unfree.
    '';
  };

  imports = [ ./overlays ];

  config = {
    nixpkgs.config = {
      allowUnfreePredicate =
        let
          homeConfigs = lib.attrValues config.home-manager.users;
          whitelist =
            (lib.concatLists (map (cfg: cfg.licht.unfreePackages) homeConfigs)) ++ config.licht.unfreePackages;
        in
        pkg: builtins.elem (lib.getName pkg) whitelist;

      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
  };
}
