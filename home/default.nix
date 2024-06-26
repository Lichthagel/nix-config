{
  osConfig,
  self,
  inputs,
  pkgs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "licht";
  home.homeDirectory = "/home/licht";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.packages = with pkgs; [
    protonvpn-gui
    protonmail-bridge
    protonmail-bridge-gui
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  services.syncthing.enable = true;

  xdg.enable = osConfig.services.xserver.enable;

  catppuccin =
    let
      ctpBase = (builtins.fromTOML (builtins.readFile (self + /config.toml))).catppuccin;
    in
    {
      enable = true;
      inherit (ctpBase) accent flavor;
    };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.agenix.homeManagerModules.default

    ./editors
    ./graphical
    ./media
    ./profiles
    ./programs
    ./services

    ./autostart.nix
    ./nixpkgs.nix

    ./shell
    ./lazygit.nix
    ./git.nix
    ./fonts.nix
    ./gpg.nix
    ./ssh.nix
  ];
}
