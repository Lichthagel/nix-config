{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.licht.editors.neovim;
in
{
  options.licht.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [ gcc ];
    };
  };
}
