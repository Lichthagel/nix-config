{ lib, ... }:
{
  options.licht.unfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''List of package names that are allowed to be unfree.'';
  };
}
