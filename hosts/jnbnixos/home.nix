{ self, pkgs, ... }:
{
  imports = [ (self + /home) ];

  home.packages = with pkgs; [ rnote ];
}
