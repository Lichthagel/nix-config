{ self, pkgs, ... }:
{
  imports = [ self.homeModules.full ];

  home.packages = with pkgs; [ rnote ];
}
